# https://github.com/nix-community/home-manager/blob/1a95e2efb477959b70b4a14c51035975c0481df6/modules/lib/generators.nix

{ lib }:
let
  inherit (lib)
    all
    any
    concatMapStringsSep
    concatStrings
    concatStringsSep
    elem
    filter
    filterAttrs
    flatten
    foldl
    generators
    hasPrefix
    isAttrs
    isList
    mapAttrsToList
    optional
    optionalString
    pipe
    replicate
    splitString
    stringToCharacters
    throwIfNot
    attrNames
    ;
  inherit (builtins) typeOf replaceStrings;

  toHyprconf =
    {
      attrs,
      indentLevel ? 0,
      importantPrefixes ? [ "$" ],
    }:
    let
      initialIndent = concatStrings (replicate indentLevel "  ");

      toHyprconf' =
        indent: attrs:
        let
          isImportantField =
            n: _: foldl (acc: prev: if hasPrefix prev n then true else acc) false importantPrefixes;
          importantFields = filterAttrs isImportantField attrs;
          withoutImportantFields = fields: removeAttrs fields (attrNames importantFields);

          allSections = filterAttrs (_n: v: isAttrs v || isList v) attrs;
          sections = withoutImportantFields allSections;

          mkSection =
            n: attrs:
            if isList attrs then
              let
                separator = if all isAttrs attrs then "\n" else "";
              in
              (concatMapStringsSep separator (a: mkSection n a) attrs)
            else if isAttrs attrs then
              ''
                ${indent}${n} {
                ${toHyprconf' "  ${indent}" attrs}${indent}}
              ''
            else
              toHyprconf' indent { ${n} = attrs; };

          mkFields = generators.toKeyValue {
            listsAsDuplicateKeys = true;
            inherit indent;
          };

          allFields = filterAttrs (_n: v: !(isAttrs v || isList v)) attrs;
          fields = withoutImportantFields allFields;
        in
        mkFields importantFields
        + concatStringsSep "\n" (mapAttrsToList mkSection sections)
        + mkFields fields;
    in
    toHyprconf' initialIndent attrs;

  toKDL =
    _:
    let
      indentStrings =
        let
          unlines = splitString "\n";
          lines = concatStringsSep "\n";
          indentAll = lines: concatStringsSep "\n" (map (x: "	" + x) lines);
        in
        stringsWithNewlines: indentAll (unlines (lines stringsWithNewlines));

      sanitizeString = replaceStrings [ "\n" ''"'' ] [ "\\n" ''\"'' ];

      literalValueToString =
        element:
        throwIfNot
          (elem (typeOf element) [
            "int"
            "float"
            "string"
            "bool"
            "null"
          ])
          "Cannot convert value of type ${typeOf element} to KDL literal."
          (
            if typeOf element == "null" then
              "null"
            else if element == false then
              "false"
            else if element == true then
              "true"
            else if typeOf element == "string" then
              ''"${sanitizeString element}"''
            else
              toString element
          );

      convertAttrsToKDL =
        name: attrs:
        let
          optArgs = map literalValueToString (attrs._args or [ ]);
          optProps = mapAttrsToList (name: value: "${name}=${literalValueToString value}") (
            attrs._props or { }
          );

          orderedChildren = pipe (attrs._children or [ ]) [
            (map (child: mapAttrsToList convertAttributeToKDL child))
            flatten
          ];
          unorderedChildren = pipe attrs [
            (filterAttrs (
              name: _:
              !(elem name [
                "_args"
                "_props"
                "_children"
              ])
            ))
            (mapAttrsToList convertAttributeToKDL)
          ];
          children = orderedChildren ++ unorderedChildren;
          optChildren = optional (children != [ ]) ''
            {
            ${indentStrings children}
            }'';

        in
        concatStringsSep " " ([ name ] ++ optArgs ++ optProps ++ optChildren);

      convertListOfFlatAttrsToKDL =
        name: list:
        let
          flatElements = map literalValueToString list;
        in
        "${name} ${concatStringsSep " " flatElements}";

      convertListOfNonFlatAttrsToKDL = name: list: ''
        ${name} {
        ${indentStrings (map (x: convertAttributeToKDL "-" x) list)}
        }'';

      convertListToKDL =
        name: list:
        let
          elementsAreFlat =
            !any (
              el:
              elem (typeOf el) [
                "list"
                "set"
              ]
            ) list;
        in
        if elementsAreFlat then
          convertListOfFlatAttrsToKDL name list
        else
          convertListOfNonFlatAttrsToKDL name list;

      convertAttributeToKDL =
        name: value:
        let
          vType = typeOf value;
        in
        if
          elem vType [
            "int"
            "float"
            "bool"
            "null"
            "string"
          ]
        then
          "${name} ${literalValueToString value}"
        else if vType == "set" then
          convertAttrsToKDL name value
        else if vType == "list" then
          if name == "_children" then
            concatStringsSep "\n" (
              map (lib.flip pipe [
                (mapAttrsToList convertAttributeToKDL)
                (concatStringsSep "\n")
              ]) value
            )
          else
            convertListToKDL name value
        else
          throw ''
            Cannot convert type `(${typeOf value})` to KDL:
              ${name} = ${toString value}
          '';
    in
    attrs: ''
      ${concatStringsSep "\n" (mapAttrsToList convertAttributeToKDL attrs)}
    '';

  toSCFG =
    _:
    let
      filterNullDirectives = filter (
        directive:
        !(directive ? "params" || directive ? "children")
        || !(directive.params or [ null ] == [ null ] && directive.children or [ ] == [ ])
      );

      indentStrings =
        let
          unlines = splitString "\n";
          lines = concatStringsSep "\n";
          indentAll = lines: concatStringsSep "\n" (map (x: "\t" + x) lines);
        in
        stringsWithNewlines: indentAll (unlines (lines stringsWithNewlines));

      specialChars =
        s:
        any (
          char:
          elem char (
            reserved
            ++ [
              " "
              "'"
              "{"
              "}"
            ]
          )
        ) (stringToCharacters s);

      sanitizeString = replaceStrings reserved [
        ''\"''
        "\\\\"
        "\\r"
        "\\n"
        "\\t"
      ];

      reserved = [
        ''"''
        "\\"
        "\r"
        "\n"
        "\t"
      ];

      literalValueToString =
        element:
        throwIfNot
          (elem (typeOf element) [
            "int"
            "float"
            "string"
            "bool"
          ])
          "Cannot convert value of type ${typeOf element} to SCFG literal."
          (
            if element == false then
              "false"
            else if element == true then
              "true"
            else if typeOf element == "string" then
              if element == "" || specialChars element then ''"${sanitizeString element}"'' else element
            else
              toString element
          );

      toOptParamsString =
        cond: list:
        optionalString cond (
          pipe list [
            (map literalValueToString)
            (concatStringsSep " ")
            (s: " " + s)
          ]
        );

      convertDirectivesToSCFG =
        directives:
        map (
          directive:
          (literalValueToString directive.name)
          + toOptParamsString (directive ? "params" && directive.params != null) directive.params
          + optionalString (directive ? "children" && directive.children != null) (
            " "
            + ''
              {
              ${indentStrings (convertDirectivesToSCFG directive.children)}
              }''
          )
        ) (filterNullDirectives directives);
    in
    directives:
    optionalString (directives != [ ]) ''
      ${concatStringsSep "\n" (convertDirectivesToSCFG directives)}
    '';
  toUserJs =
    settings:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: value: "user_pref(\"${name}\", ${builtins.toJSON value});") settings
    );

  toOMP =
    theme:
    let
      indentStr = n: concatStrings (replicate n "  ");

      go =
        indent: value:
        if builtins.isAttrs value then
          if value == { } then
            "{}"
          else
            "{\n"
            + concatStringsSep ",\n" (
              mapAttrsToList (k: v: "${indentStr (indent + 1)}${builtins.toJSON k}: ${go (indent + 1) v}") value
            )
            + "\n${indentStr indent}}"
        else if builtins.isList value then
          if value == [ ] then
            "[]"
          else
            "[\n"
            + concatStringsSep ",\n" (map (v: "${indentStr (indent + 1)}${go (indent + 1) v}") value)
            + "\n${indentStr indent}]"
        else
          builtins.toJSON value;
    in
    go 0 theme;

  toGituiTheme =
    attrs:
    "(\n${
      concatStringsSep "\n" (mapAttrsToList (name: value: "    ${name}: Some(\"${value}\"),") attrs)
    }\n)";
in
{
  inherit
    toHyprconf
    toKDL
    toSCFG
    toOMP
    toGituiTheme
    toUserJs
    ;
}

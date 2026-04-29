defmodule BoringAvatar.SVG do
  elements = [
    "a",
    "animate",
    "animateMotion",
    "animateTransform",
    "circle",
    "clipPath",
    "defs",
    "desc",
    "ellipse",
    "feBlend",
    "feColorMatrix",
    "feComponentTransfer",
    "feComposite",
    "feConvolveMatrix",
    "feDiffuseLighting",
    "feDisplacementMap",
    "feDistantLight",
    "feDropShadow",
    "feFlood",
    "feFuncA",
    "feFuncB",
    "feFuncG",
    "feFuncR",
    "feGaussianBlur",
    "feImage",
    "feMerge",
    "feMergeNode",
    "feMorphology",
    "feOffset",
    "fePointLight",
    "feSpecularLighting",
    "feSpotLight",
    "feTile",
    "feTurbulence",
    "filter",
    "foreignObject",
    "g",
    "image",
    "line",
    "linearGradient",
    "marker",
    "mask",
    "metadata",
    "mpath",
    "path",
    "pattern",
    "polygon",
    "polyline",
    "radialGradient",
    "rect",
    "script",
    "set",
    "stop",
    "style",
    "svg",
    "switch",
    "symbol",
    "text",
    "textPath",
    "title",
    "tspan",
    "use",
    "view"
  ]

  import BoringAvatar.Syntax

  for name <- elements do
    tag_name = name |> Macro.underscore() |> String.to_atom()

    defmacro unquote(tag_name)(args \\ [], children \\ nil) do
      name = unquote(name)

      if(!is_valid_name(name)) do
        raise "Invalid tag name #{inspect(name)}"
      end

      tag_start = [?<, name]

      attributes =
        for {name, value} <- args do
          name =
            case name do
              name when is_atom(name) -> String.Chars.to_string(name) |> String.replace("_", "-")
              name -> String.Chars.to_string(name)
            end

          if(!is_valid_name(name)) do
            raise "Invalid attribute name #{inspect(name)}"
          end

          [
            ?\s,
            name,
            ?=,
            ?",
            quote(do: html_escape_to_iodata(String.Chars.to_string(unquote(value)))),
            ?"
          ]
        end

      body =
        case children do
          nil -> " />"
          do: {:__block__, _, v} -> [?>, v, ?<, ?/, name, ?>]
          do: v -> [?>, v, ?<, ?/, name, ?>]
          v -> [?>, v, ?<, ?/, name, ?>]
        end

      [tag_start, attributes, body]
    end
  end

  defmacro transform(p, size, transformations) do
    transformations = Enum.uniq(transformations)

    Enum.map(transformations, fn
      :translate ->
        quote(
          do: [
            "translate(",
            String.Chars.to_string(unquote(p).translate_x),
            ?\s,
            String.Chars.to_string(unquote(p).translate_y),
            ?)
          ]
        )

      :rotate ->
        quote(
          do: [
            "rotate(",
            String.Chars.to_string(unquote(p).rotate),
            ?\s,
            String.Chars.to_string(unquote(size) / 2),
            ?\s,
            String.Chars.to_string(unquote(size) / 2),
            ?)
          ]
        )

      :scale ->
        quote(
          do: [
            "scale(",
            String.Chars.to_string(unquote(p).scale),
            ?)
          ]
        )
    end)
    |> Enum.intersperse(?\s)
  end

  defmacro transform(do: transformations) do
    transformations =
      case transformations do
        {:__block__, _, v} -> v
        v -> [v]
      end

    for {name, _, args} <- transformations do
      args =
        Enum.map(args, fn arg ->
          quote(do: String.Chars.to_string(unquote(arg)))
        end)

      [String.Chars.to_string(name), ?(, Enum.intersperse(args, ?\s), ?)]
    end
    |> Enum.intersperse(?\s)
  end
end

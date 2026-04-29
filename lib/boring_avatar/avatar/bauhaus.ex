defmodule BoringAvatar.Variant.Bauhaus do
  @size 80

  import BoringAvatar.Utilities
  import BoringAvatar.SVG

  @behaviour BoringAvatar

  def avatar(
        %BoringAvatar{
          name: name,
          colours: colours,
          title: title,
          size: size,
          square: square
        } = props
      ) do
    num_from_name = hash_code(name)
    range = length(colours)

    properties =
      &%{
        colour: get_random_colour(num_from_name + &1, colours, range),
        translate_x: get_unit(num_from_name * (&1 + 1), @size / 10, 1),
        translate_y: get_unit(num_from_name * (&1 + 1), @size / 10, 2),
        rotate: get_unit(num_from_name * (&1 + 1), 360, 1)
      }

    is_square = get_boolean(num_from_name, 2)

    mask_id = unique_id(props)

    svg(
      viewBox: "0 0 #{@size} #{@size}",
      fill: "none",
      role: "img",
      xmlns: "http://www.w3.org/2000/svg",
      width: size,
      height: size
    ) do
      if(title, do: title([], title), else: "")

      mask(
        id: mask_id,
        maskUnits: "userSpaceOnUse",
        x: 0,
        y: 0,
        width: @size,
        height: @size
      ) do
        rect(width: @size, height: @size, rx: if(square, do: 0, else: @size * 2), fill: "#FFFFFF")
      end

      g(mask: "url(##{mask_id})") do
        rect(width: @size, height: @size, fill: properties.(0).colour)

        (
          p = properties.(1)

          rect(
            x: (@size - 60) / 2,
            y: (@size - 20) / 2,
            width: @size,
            height: if(is_square, do: @size, else: @size / 8),
            fill: p.colour,
            transform:
              transform do
                translate(p.translate_x, p.translate_y)
                rotate(p.rotate, @size / 2, @size / 2)
              end
          )
        )

        (
          p = properties.(2)

          circle(
            cx: @size / 2,
            cy: @size / 2,
            fill: p.colour,
            r: @size / 5,
            transform: transform(p, @size, [:translate])
          )
        )

        (
          p = properties.(3)

          line(
            x1: 0,
            y1: @size / 2,
            x2: @size,
            y2: @size / 2,
            stroke_width: 2,
            stroke: p.colour,
            transform: transform(p, @size, [:translate, :rotate])
          )
        )
      end

      defs [] do
        filter(
          id: "filter_#{mask_id}",
          filterUnits: "userSpaceOnUse",
          colorInterpolationFilters: "sRGB"
        ) do
          fe_flood(flood_opacity: 0, result: "BackgroundImageFix")
          fe_blend(in: "SourceGraphic", in2: "BackgroundImageFix", result: "shape")
          fe_gaussian_blur(stdDeviation: 7, result: "effect1_foregroundBlur")
        end
      end
    end
  end
end

defmodule BoringAvatar.Variant.Marble do
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

    property = fn
      i, :colour -> get_random_colour(num_from_name + i, colours, range)
      i, :translate_x -> get_unit(num_from_name * (i + 1), @size / 10, 1)
      i, :translate_y -> get_unit(num_from_name * (i + 1), @size / 10, 2)
      i, :scale -> 1.2 + get_unit(num_from_name * (i + 1), @size / 20) / 10
      i, :rotate -> get_unit(num_from_name * (i + 1), 360, 1)
    end

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
        rect(width: @size, height: @size, fill: property.(0, :colour))

        path(
          filter: "url(#filter_#{mask_id})",
          d: "M32.414 59.35L50.376 70.5H72.5v-71H33.728L26.5 13.381l19.057 27.08L32.414 59.35z",
          fill: property.(1, :colour),
          transform:
            transform do
              translate(property.(1, :translate_x), property.(1, :translate_y))
              rotate(property.(1, :rotate), @size / 2, @size / 2)
              scale(property.(1, :scale))
            end
        )

        path(
          filter: "url(#filter_#{mask_id})",
          style: "mix-blend-mode: overlay",
          d:
            "M22.216 24L0 46.75l14.108 38.129L78 86l-3.081-59.276-22.378 4.005 12.972 20.186-23.35 27.395L22.215 24z",
          fill: property.(2, :colour),
          transform:
            transform do
              translate(property.(2, :translate_x), property.(2, :translate_y))
              rotate(property.(2, :rotate), @size / 2, @size / 2)
              scale(property.(2, :scale))
            end
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

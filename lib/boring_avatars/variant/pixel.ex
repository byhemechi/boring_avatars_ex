defmodule BoringAvatars.Variant.Pixel do
  @behaviour BoringAvatars
  @size 80

  import BoringAvatars.Utilities
  import BoringAvatars.SVG

  defp x_coord(k) do
    20 * rem(k, 4) + 10 * div(k, 4)
  end

  defp pixel_coords(i) when is_integer(i) and i < 8 do
    {x_coord(i), 0}
  end

  defp pixel_coords(i) when is_integer(i) and i >= 8 do
    k = div(i - 8, 7)
    y_step = rem(i - 8, 7)

    {x_coord(k), 10 * (y_step + 1)}
  end

  @impl BoringAvatars
  def avatar(props \\ %BoringAvatars.Props{})
  def avatar(props) when is_list(props), do: avatar(BoringAvatars.Props.__struct__(props))

  def avatar(
        %BoringAvatars.Props{
          name: name,
          colours: colours,
          title: title,
          size: size,
          square: square
        } = props
      ) do
    num_from_name = hash_code(name)
    range = length(colours)

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
        for i <- 0..63 do
          {x, y} = pixel_coords(i)

          rect(
            x: x,
            y: y,
            width: 10,
            height: 10,
            fill: get_random_colour(num_from_name |> rem(i + 1), colours, range)
          )
        end
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

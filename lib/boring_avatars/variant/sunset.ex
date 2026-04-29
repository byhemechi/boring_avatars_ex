defmodule BoringAvatars.Variant.Sunset do
  @behaviour BoringAvatars
  @size 80

  import BoringAvatars.Utilities
  import BoringAvatars.SVG

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

    colours = &get_random_colour(num_from_name + &1, colours, range)

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
        path(fill: "url(#gradient_1_#{mask_id})", d: "M0 0h80v40H0z")
        path(fill: "url(#gradient_2_#{mask_id})", d: "M0 40h80v40H0z")
      end

      defs [] do
        linear_gradient(
          id: "gradient_1_#{mask_id}",
          x1: @size / 2,
          y1: 0,
          x2: @size / 2,
          y2: @size / 2,
          gradientUnits: "userSpaceOnUse"
        ) do
          stop(stop_color: colours.(0))
          stop(offset: 1, stop_color: colours.(1))
        end

        linear_gradient(
          id: "gradient_2_#{mask_id}",
          y1: @size / 2,
          y2: @size,
          gradientUnits: "userSpaceOnUse"
        ) do
          stop(stop_color: colours.(2))
          stop(offset: 1, stop_color: colours.(3))
        end
      end
    end
  end
end

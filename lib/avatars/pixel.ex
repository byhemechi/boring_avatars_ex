defmodule BoringAvatars.Avatars.Pixel do
  @moduledoc """
  Pixel style avatar implementation
  """

  import Phoenix.Component
  alias BoringAvatars.Utilities

  @elements 64
  @size 80
  @cell_size 10

  defp generate_colors(name, colors) do
    num_from_name = Utilities.hash_code(name)
    range = if colors, do: length(colors), else: 0

    Enum.map(0..(@elements - 1), fn i ->
      Utilities.get_random_color(rem(num_from_name, i + 1), colors, range)
    end)
  end

  def render(assigns) do
    pixel_colors = generate_colors(assigns.name, assigns.colors)
    mask_id = "mask_#{:erlang.phash2(assigns.name)}"

    size_attr =
      if Map.has_key?(assigns, :size), do: [width: assigns.size, height: assigns.size], else: []

    rx = if assigns.square, do: nil, else: @size * 2

    # Generate pixel positions
    pixels =
      for y <- 0..7, x <- 0..7 do
        %{
          x: x * @cell_size,
          y: y * @cell_size,
          width: @cell_size,
          height: @cell_size,
          color: Enum.at(pixel_colors, y * 8 + x)
        }
      end

    assigns =
      assign(assigns,
        pixels: pixels,
        mask_id: mask_id,
        size: @size,
        size_attr: size_attr,
        rx: rx
      )

    ~H"""
    <svg
      viewBox={"0 0 #{@size} #{@size}"}
      fill="none"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      {@size_attr}
    >
      <%= if @title do %>
        <title><%= @name %></title>
      <% end %>
      <mask
        id={@mask_id}
        mask-type="alpha"
        maskUnits="userSpaceOnUse"
        x={0}
        y={0}
        width={@size}
        height={@size}
      >
        <rect width={@size} height={@size} rx={@rx} fill="#FFFFFF" />
      </mask>
      <g mask={"url(##{@mask_id})"}>
        <%= for pixel <- @pixels do %>
          <rect
            x={pixel.x}
            y={pixel.y}
            width={pixel.width}
            height={pixel.height}
            fill={pixel.color}
          />
        <% end %>
      </g>
    </svg>
    """
  end
end

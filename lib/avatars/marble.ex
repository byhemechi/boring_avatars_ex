defmodule BoringAvatars.Avatars.Marble do
  @moduledoc """
  Marble style avatar implementation
  """

  import Phoenix.Component
  alias BoringAvatars.Utilities

  @elements 3
  @size 80

  defp generate_colors(name, colors) do
    num_from_name = Utilities.hash_code(name)
    range = if colors, do: length(colors), else: 0

    Enum.map(0..(@elements - 1), fn i ->
      %{
        color: Utilities.get_random_color(num_from_name + i, colors, range),
        translate_x: Utilities.get_unit(num_from_name * (i + 1), div(@size, 10), 1),
        translate_y: Utilities.get_unit(num_from_name * (i + 1), div(@size, 10), 2),
        scale: 1.2 + Utilities.get_unit(num_from_name * (i + 1), div(@size, 20)) / 10,
        rotate: Utilities.get_unit(num_from_name * (i + 1), 360, 1)
      }
    end)
  end

  def render(assigns) do
    properties = generate_colors(assigns.name, assigns.colors)
    mask_id = "mask_#{:erlang.phash2(assigns.name)}"
    filter_id = "filter_#{mask_id}"

    size_attr =
      if Map.has_key?(assigns, :size), do: [width: assigns.size, height: assigns.size], else: []

    rx = if assigns.square, do: nil, else: @size * 2

    assigns =
      assign(assigns,
        properties: properties,
        mask_id: mask_id,
        filter_id: filter_id,
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
      <mask id={@mask_id} maskUnits="userSpaceOnUse" x={0} y={0} width={@size} height={@size}>
        <rect width={@size} height={@size} rx={@rx} fill="#FFFFFF" />
      </mask>
      <g mask={"url(##{@mask_id})"}>
        <rect width={@size} height={@size} fill={Enum.at(@properties, 0).color} />
        <path
          filter={"url(##{@filter_id})"}
          d="M32.414 59.35L50.376 70.5H72.5v-71H33.728L26.5 13.381l19.057 27.08L32.414 59.35z"
          fill={Enum.at(@properties, 1).color}
          transform={"translate(#{Enum.at(@properties, 1).translate_x} #{Enum.at(@properties, 1).translate_y}) rotate(#{Enum.at(@properties, 1).rotate} #{@size / 2} #{@size / 2}) scale(#{Enum.at(@properties, 2).scale})"}
        />
        <path
          filter={"url(##{@filter_id})"}
          style="mix-blend-mode: overlay;"
          d="M22.216 24L0 46.75l14.108 38.129L78 86l-3.081-59.276-22.378 4.005 12.972 20.186-23.35 27.395L22.215 24z"
          fill={Enum.at(@properties, 2).color}
          transform={"translate(#{Enum.at(@properties, 2).translate_x} #{Enum.at(@properties, 2).translate_y}) rotate(#{Enum.at(@properties, 2).rotate} #{@size / 2} #{@size / 2}) scale(#{Enum.at(@properties, 2).scale})"}
        />
      </g>
      <defs>
        <filter
          id={@filter_id}
          filterUnits="userSpaceOnUse"
          color-interpolation-filters="sRGB"
        >
          <feFlood flood-opacity={0} result="BackgroundImageFix" />
          <feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
          <feGaussianBlur stdDeviation={7} result="effect1_foregroundBlur" />
        </filter>
      </defs>
    </svg>
    """
  end
end

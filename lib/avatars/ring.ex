defmodule BoringAvatars.Avatars.Ring do
  @moduledoc """
  Ring style avatar implementation
  """

  import Phoenix.Component
  alias BoringAvatars.Utilities

  @size 90
  @colors 5

  defp generate_colors(colors, name) do
    num_from_name = Utilities.hash_code(name)
    range = if colors, do: length(colors), else: 0

    colors_shuffle =
      Enum.map(0..(@colors - 1), fn i ->
        Utilities.get_random_color(num_from_name + i, colors, range)
      end)

    [
      Enum.at(colors_shuffle, 0),
      Enum.at(colors_shuffle, 1),
      Enum.at(colors_shuffle, 1),
      Enum.at(colors_shuffle, 2),
      Enum.at(colors_shuffle, 2),
      Enum.at(colors_shuffle, 3),
      Enum.at(colors_shuffle, 3),
      Enum.at(colors_shuffle, 0),
      Enum.at(colors_shuffle, 4)
    ]
  end

  def render(assigns) do
    ring_colors = generate_colors(assigns.colors, assigns.name)
    mask_id = "mask_#{:erlang.phash2(assigns.name)}"

    size_attr =
      if Map.has_key?(assigns, :size), do: [width: assigns.size, height: assigns.size], else: []

    rx = if assigns.square, do: nil, else: @size * 2

    assigns =
      assign(assigns,
        ring_colors: ring_colors,
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
      <mask id={@mask_id} maskUnits="userSpaceOnUse" x={0} y={0} width={@size} height={@size}>
        <rect width={@size} height={@size} rx={@rx} fill="#FFFFFF" />
      </mask>
      <g mask={"url(##{@mask_id})"}>
        <path d="M0 0h90v45H0z" fill={Enum.at(@ring_colors, 0)} />
        <path d="M0 45h90v45H0z" fill={Enum.at(@ring_colors, 1)} />
        <path d="M83 45a38 38 0 00-76 0h76z" fill={Enum.at(@ring_colors, 2)} />
        <path d="M83 45a38 38 0 01-76 0h76z" fill={Enum.at(@ring_colors, 3)} />
        <path d="M77 45a32 32 0 10-64 0h64z" fill={Enum.at(@ring_colors, 4)} />
        <path d="M77 45a32 32 0 11-64 0h64z" fill={Enum.at(@ring_colors, 5)} />
        <path d="M71 45a26 26 0 00-52 0h52z" fill={Enum.at(@ring_colors, 6)} />
        <path d="M71 45a26 26 0 01-52 0h52z" fill={Enum.at(@ring_colors, 7)} />
        <circle cx={45} cy={45} r={23} fill={Enum.at(@ring_colors, 8)} />
      </g>
    </svg>
    """
  end
end

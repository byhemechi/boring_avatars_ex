defmodule BoringAvatar.Syntax do
  {:__block__, _, allowed_first_chars} =
    quote do
      ~c":_"
      ?a..?z
      ?A..?Z
      0xC0..0xD6
      0xD8..0xF6
      0xF8..0x2FF
      0x370..0x37D
      0x37F..0x1FFF
      0x200C..0x200D
      0x2070..0x218F
      0x2C00..0x2FEF
      0x3001..0xD7FF
      0xF900..0xFDCF
      0xFDF0..0xFFFD
      0x10000..0xEFFFF
    end

  {:__block__, _, allowed_chars} =
    quote do
      [?-, ?., 0xB7]
      ?0..?9
      0x0300..0x036F
      0x203F..0x2040
    end

  defguard is_allowed_first_char(c)
           when unquote(
                  for pattern <- allowed_first_chars, reduce: nil do
                    nil -> {:in, [], [Macro.var(:c, nil), pattern]}
                    v -> {:or, [], [v, {:in, [], [Macro.var(:c, nil), pattern]}]}
                  end
                )

  defguard is_allowed_char(c)
           when is_allowed_first_char(c) or
                  unquote(
                    for pattern <- allowed_chars, reduce: nil do
                      nil -> {:in, [], [Macro.var(:c, nil), pattern]}
                      v -> {:or, [], [v, {:in, [], [Macro.var(:c, nil), pattern]}]}
                    end
                  )

  def is_valid_name(binary, is_first_char \\ true)

  def is_valid_name(<<c::utf8, rest::binary>>, true) when is_allowed_first_char(c),
    do: is_valid_name(rest, false)

  def is_valid_name(<<c::utf8, rest::binary>>, false) when is_allowed_char(c),
    do: is_valid_name(rest, false)

  def is_valid_name("", false), do: true
  def is_valid_name(_, _), do: false

  # HTML escaping taken from Plug.HTML
  @spec html_escape(String.t()) :: String.t()
  def html_escape(data) when is_binary(data) do
    IO.iodata_to_binary(to_iodata(data, 0, data, []))
  end

  @spec html_escape_to_iodata(String.t()) :: iodata
  def html_escape_to_iodata(data) when is_binary(data) do
    to_iodata(data, 0, data, [])
  end

  escapes = [
    {?<, "&lt;"},
    {?>, "&gt;"},
    {?&, "&amp;"},
    {?", "&quot;"},
    {?', "&#39;"}
  ]

  for {match, insert} <- escapes do
    defp to_iodata(<<unquote(match), rest::bits>>, skip, original, acc) do
      to_iodata(rest, skip + 1, original, [acc | unquote(insert)])
    end
  end

  defp to_iodata(<<_char, rest::bits>>, skip, original, acc) do
    to_iodata(rest, skip, original, acc, 1)
  end

  defp to_iodata(<<>>, _skip, _original, acc) do
    acc
  end

  for {match, insert} <- escapes do
    defp to_iodata(<<unquote(match), rest::bits>>, skip, original, acc, len) do
      part = binary_part(original, skip, len)
      to_iodata(rest, skip + len + 1, original, [acc, part | unquote(insert)])
    end
  end

  defp to_iodata(<<_char, rest::bits>>, skip, original, acc, len) do
    to_iodata(rest, skip, original, acc, len + 1)
  end

  defp to_iodata(<<>>, 0, original, _acc, _len) do
    original
  end
w
  defp to_iodata(<<>>, skip, original, acc, len) do
    [acc | binary_part(original, skip, len)]
  end
end

defmodule OED.Client do
  @app_id Application.get_env(:oed, :app_id)
  @app_key Application.get_env(:oed, :app_key)

  def fetch(entry) do
    entry_url(entry)
    |> HTTPoison.get(headers)
    |> handle_response
  end

  defp headers do
    [
      {"app_id", @app_id},
      {"app_key", @app_key},
    ]
  end

  defp entry_url(entry, lang \\ "en") do
    "https://od-api.oxforddictionaries.com:443/api/v1/entries/#{lang}/#{entry}"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    { :ok, Poison.Parser.parse!(body) }
  end

  defp handle_response({:ok, %{status_code: 404, body: body}}) do
    { :not_found, Poison.Parser.parse!(body) }
  end

  defp handle_response({:error, %{body: body}}), do: { :error, body }
end

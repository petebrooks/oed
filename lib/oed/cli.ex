defmodule OED.CLI do
  alias OED.Client

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  defp process(:help) do
    # TODO
  end

  defp process({entry}) do
    Client.fetch(entry)
    |> print
  end

  defp parse_args(argv) do
    parse = OptionParser.parse(
      argv,
      switches: [ help: :boolean],
      aliases:  [ h: :help ],
    )

    case parse do
       { [ help: true ], _, _ } -> :help
       { _, [ entry ], _ } -> { entry }
       _ -> :help
    end
  end

  defp print({:ok, result}) do
    result["results"]
    |> Enum.each(&print_lexical_entries/1)
  end

  defp print({:error, reason}) do
    IO.puts "Error: #{reason}"
  end

  defp print_lexical_entries(result) do
    IO.puts result["word"]
    IO.inspect result["lexicalEntries"]
  end
end

# JavaScript syntax highlighter

# Rodrigo Núñez Magallanes, A01028310
# Andrea Alexandra Barrón Córdova, A01783126

defmodule JSSH do
  def run() do
    in_filename = "test.js" # this will be inputted in the end
    out_filename = "index.html"
    doc_head = """
    <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8" />
          <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <link rel="stylesheet" href="styles.css" />
          <link rel="preconnect" href="https://fonts.googleapis.com">
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
          <link href="https://fonts.googleapis.com/css2?family=Open+Sans&display=swap" rel="stylesheet">
          <title>JS Syntax Highlighter</title></head><body><pre>
    """

    # initialize html output file
    File.write(out_filename, doc_head)

    # read js file
    code = File.read!(in_filename)
    write_file(code, out_filename)
    File.write(out_filename, "</pre></body></html>", [:append])

  end

  defp write_file(code, out_filename) do
    code
    # split the code by lines
    |> String.split("\n")
    # remove trailing spaces and \r
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.map(fn line ->
      inspect_line(line, out_filename)
    end)
  end

  defp inspect_line("", out_filename), do: File.write(out_filename, "<br>", [:append])
  defp inspect_line(line, out_filename) do
    # Regular expressions
    commentRegex = ~r/^\/\/.*/
    stringRegex = ~r/^(["'])(?:(?=(\\?))\2.)*?\1/
    keywordRegex = ~r/^\b(?:abstract|await|boolean|break|byte|case|catch|char|class|const|continue|debugger|default|delete|do|double|else|enum|export|extends|final|finally|float|for|function|goto|if|implements|import|in|instanceof|int|interface|let|long|native|new|null|package|private|protected|public|return|short|static|super|switch|synchronized|this|throw|throws|transient|try|typeof|var|void|volatile|while|with|yield)\b/
    numberRegex = ~r/^\b-?\d+\.?(\d+)?\b/
    booleanRegex = ~r/^\b(?:true|false)\b/
    equalRegex = ~r/^=/
    spaceRegex = ~r/^\s+/
    varRegex = ~r/^[a-zA-Z_$][a-zA-Z0-9_$]*/
    mathRegex = ~r/^(\+|\-|\/|\*|%)/
    divRegex = ~r/^\//
    punctuationRegex = ~r/^[;,]/
    # matches any non-space character (words that we don't want to highlight)
    anyRegex = ~r/^\S+/
    specialsRegex = ~r/^(\(|\)|\{|\}|\[|\])/

    cond do
      Regex.match?(commentRegex, line) ->
        [head | _] = Regex.run(commentRegex, line)
        html = "<span class=\"comment\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(commentRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(stringRegex, line) ->
        [head | _] = Regex.run(stringRegex, line)
        html = "<span class=\"string\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(stringRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(keywordRegex, line) ->
        [head | _] = Regex.run(keywordRegex, line)
        html = "<span class=\"keyword\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(keywordRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(spaceRegex, line) ->
        [head | _] = Regex.run(spaceRegex, line)
        html = "<span class=\"space\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(spaceRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(booleanRegex, line) ->
        [head | _] = Regex.run(booleanRegex, line)
        html = "<span class=\"boolean\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(booleanRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(varRegex, line) ->
        [head | _] = Regex.run(varRegex, line)
        html = "<span>#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(varRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(equalRegex, line) ->
        [head | _] = Regex.run(equalRegex, line)
        html = "<span class=\"boolean\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(equalRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(numberRegex, line) ->
        [head | _] = Regex.run(numberRegex, line)
        html = "<span class=\"number\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(numberRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(specialsRegex, line) ->
        [head | _] = Regex.run(specialsRegex, line)
        html = "<span class=\"special\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(specialsRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(mathRegex, line) ->
        [head | _] = Regex.run(mathRegex, line)
        html = "<span class=\"boolean\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(mathRegex, line, "", global: false)
        inspect_line(line, out_filename)
      Regex.match?(punctuationRegex, line) ->
        [head | _] = Regex.run(punctuationRegex, line)
        html = "<span class=\"punctuation\">#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(punctuationRegex, line, "", global: false)
        inspect_line(line, out_filename)
      true ->
        [head | _] = Regex.run(anyRegex, line)
        html = "<span>#{head}</span>"
        File.write(out_filename, html, [:append])
        line = Regex.replace(anyRegex, line, "", global: false)
        inspect_line(line, out_filename)
    end
  end

end

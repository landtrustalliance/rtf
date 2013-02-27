require File.expand_path(File.dirname(__FILE__)+'/../helper_tests')
require 'rtf'
require 'rtf/converters'

class HTMLConverterTest < Test::Unit::TestCase
  def setup
    @html = <<-HTML
    <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <h1>Hello!</h1>
        <p>Hi</p><br/><p>Bye</p>

        <ul>
          <li>lists</li>
          <li>are</li>
          <li>fun</li>
        </ul>

        <table>
          <tr>
            <td>Me</td> <td> or </td> <td> me </td>
          </tr>
          <tr>
            <td>Hi</td><td>Hello</td><td><strong>HI</strong></td>
          </tr>
        </table>
      </body>
    </html>
    HTML
  end

  def test_converts_html
    response = RTF::Converters::HTML.new("<h1>Hi</h1>").to_rtf
    assert(response.match(/{\\b\\fs44\nHi\n}\n{\\line}/))
  end

  def test_converts_table
    response = RTF::Converters::HTML.new(setup).to_rtf
    assert(response.match(/\n\\trowd\\tgraph100\n\\cellx300\n\\cellx600\n\\cellx900\n\\pard\\intbl\nMe\n\\cell\n\\pard\\intbl\nor\n\\cell\n\\pard\\intbl\nme\n\\cell\n\\row\n\\trowd\\tgraph100\n\\cellx300\n\\cellx600\n\\cellx900\n\\pard\\intbl\nHi\n\\cell\n\\pard\\intbl\nHello\n\\cell\n\\pard\\intbl\n{\\b\nHI\n}\n\\cell\n\\lastrow\n\\row\n}/))
  end

end

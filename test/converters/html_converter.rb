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
          <thead>
            <tr>
              <th>Me</th> <th> or </th> <th> me </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Hi</td><td>Hello</td><td><strong>HI</strong></td>
            </tr>
          </tbody>
        </table>

      </body>
    </html>
    HTML
  end

  def test_converts_html
    response = RTF::Converters::HTML.new("<h1>Hi</h1>").to_rtf
    assert(response.match(/{\\b\\fs44\nHi\n}\n{\\line}/))
  end

  def test_converts_empty_table_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table></table>").to_rtf
    end
  end

  def test_converts_table_with_single_row_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table><tr></tr></table>").to_rtf
    end
  end

  def test_converts_table_with_thead_and_header_row_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table><thead><tr><th>Awesome</th></tr></thead></table>").to_rtf
    end
  end

  def test_converts_table_with_headers_and_no_rows_or_cells_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table><tr><th>first</th><th>second</th></tr></table>").to_rtf
    end
  end

  def test_converts_tables_with_thead_and_tbody_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table>
                                  <thead>
                                    <tr>
                                      <th>first</th><th>second</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <tr>
                                      <td>bill</td><td>bob</td>
                                    </tr>
                                  </tbody>
                                 </table>").to_rtf
    end
  end

  def test_converts_table_with_no_cells_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table>
                                  <tr><td>hi</td></tr>
                                  <tr></tr>
                                </table>").to_rtf
    end
  end

  def test_converts_html_file_with_table
    response = RTF::Converters::HTML.new(setup).to_rtf
    assert_match(/\n\\trowd\\tgraph100\n\\cellx300\n\\cellx600\n\\cellx900\n\\pard\\intbl\nMe\n\\cell\n\\pard\\intbl\nor\n\\cell\n\\pard\\intbl\nme\n\\cell\n\\row\n\\trowd\\tgraph100\n\\cellx300\n\\cellx600\n\\cellx900\n\\pard\\intbl\nHi\n\\cell\n\\pard\\intbl\nHello\n\\cell\n\\pard\\intbl\n{\\b\nHI\n}\n\\cell\n\\lastrow\n\\row\n}/, response)
  end

  def test_converts_multi_row_table_with_thead_and_no_tbody
    assert_nothing_raised do
      RTF::Converters::HTML.new('
        <table>
          <thead>
            <tr>
              <th>Activity</th>
            </tr>
          </thead>
          <tr>
            <td>February 2013</td>
          </tr>
          <tr>
            <td>Awesome Sauce</td>
          </tr>
        </table>').to_rtf
    end
  end

  def test_table_with_html_in_cells
    assert_nothing_raised do
      RTF::Converters::HTML.new('
          <table class="table table-bordered table-condensed">
            <thead>
              <tr>
                <th></th>
                <th>Publication Name</th>
                <th>Publication Date</th>
              </tr>
            </thead>
            <tr>
              <td>1</td>
              <td><p>lorem em ipsum</p></td>
              <td></td>
            </tr>
            <tr>
              <td>2</td>
              <td><p>lorem em ipsum</p></td>
              <td>12/11/10</td>
            </tr>
            <tr>
              <td>3</td>
              <td><p>lorem em ipsum</p></td>
              <td>Feb 10th 2012</td>
            </tr>
        </table>').to_rtf
    end
  end

end

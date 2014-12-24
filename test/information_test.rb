require 'test_helper'

# Information class unit test class.
class InformationTest < Test::Unit::TestCase
   def test_01
      date = Time.local(1985, 6, 22, 14, 33, 22)
      info = []
      info.push(Information.new)
      info.push(Information.new('Title 1'))
      info.push(Information.new('Title 2', 'Peter Wood'))
      info.push(Information.new('La la la', '', 'Nowhere Ltd.'))
      info.push(Information.new('', 'N. O. Body', 'Oobly', 'Joobly'))
      info.push(Information.new('Title 5', 'J. Bloggs', '', '', date))
      info.push(Information.new('Title 6', 'J. Bloggs', '', '', '1985-06-22 14:33:22 GMT'))

      assert_nil info[0].title
      assert_nil info[0].author
      assert_nil info[0].company
      assert_nil info[0].comments

      assert_equal 'Title 1', info[1].title
      assert_nil   info[1].author
      assert_nil   info[1].company
      assert_nil   info[1].comments

      assert_equal 'Title 2', info[2].title
      assert_equal 'Peter Wood', info[2].author
      assert_nil   info[2].company
      assert_nil   info[2].comments

      assert_equal 'La la la', info[3].title
      assert_equal '', info[3].author
      assert_equal 'Nowhere Ltd.', info[3].company
      assert_nil   info[3].comments

      assert_equal '', info[4].title
      assert_equal 'N. O. Body', info[4].author
      assert_equal 'Oobly', info[4].company
      assert_equal 'Joobly', info[4].comments

      assert_equal 'Title 5', info[5].title
      assert_equal 'J. Bloggs', info[5].author
      assert_equal '', info[5].company
      assert_equal '', info[5].comments
      assert_equal date, info[5].created

      assert_equal 'Title 6', info[6].title
      assert_equal 'J. Bloggs', info[6].author
      assert_equal '', info[6].company
      assert_equal '', info[6].comments
      assert_equal date, info[6].created

      info[6].title = 'Alternative Title'
      assert_equal 'Alternative Title', info[6].title

      info[6].author = 'A. Person'
      assert_equal 'A. Person', info[6].author

      info[6].company = nil
      assert_nil info[6].company

      info[6].comments = 'New information comment text.'
      assert_equal 'New information comment text.', info[6].comments

      date = Time.new
      info[6].created = date
      assert_equal date, info[6].created

      date = Time.local(1985, 6, 22, 14, 33, 22)
      info[6].created = '1985-06-22 14:33:22 GMT'
      assert_equal date, info[6].created

      assert_equal "  Information\n     Created:  "\
                   "#{info[0].created}",
                   info[0].to_s(2)
      assert_equal "    Information\n       Title:    Title 1\n"\
                   "       Created:  #{info[1].created}",
                   info[1].to_s(4)
      assert "Information\n   Title:    Title 2\n   "\
             "Author:   Peter Wood\n   Created:  "\
             "#{info[2].created}",
             info[2].to_s(-10)
      assert_equal "Information\n   Title:    La la la\n   "\
                    "Author:   \n   Company:  Nowhere Ltd.\n   "\
                    "Created:  #{info[3].created}",
                    info[3].to_s
      assert_equal "Information\n   Title:    \n   Author:   "\
                   "N. O. Body\n   Company:  Oobly\n   Comments: "\
                   "Joobly\n   Created:  #{info[4].created}",
                   info[4].to_s
      assert_equal "Information\n   Title:    Title 5\n   Author:   "\
                   "J. Bloggs\n   Company:  \n   Comments: \n   "\
                   "Created:  #{date}",
                   info[5].to_s
      assert_equal "Information\n   Title:    Alternative Title"\
                   "\n   Author:   A. Person\n   Comments: New "\
                   "information comment text.\n   Created:  #{date}",
                   info[6].to_s

      assert_equal "   {\\info\n   #{to_rtf(info[0].created)}"\
                   "\n   }",
                   info[0].to_rtf(3)
      assert_equal "      {\\info\n      {\\title Title 1}\n"\
                   "      #{to_rtf(info[1].created)}\n      }",
                   info[1].to_rtf(6)
      assert_equal "{\\info\n{\\title Title 2}\n"\
                   "{\\author Peter Wood}\n"\
                   "#{to_rtf(info[2].created)}\n}",
                   info[2].to_rtf(-5)
      assert_equal "{\\info\n{\\title La la la}\n"\
                   "{\\author }\n"\
                   "{\\company Nowhere Ltd.}\n"\
                   "#{to_rtf(info[3].created)}\n}",
                   info[3].to_rtf
      assert_equal "{\\info\n{\\title }\n"\
                   "{\\author N. O. Body}\n"\
                   "{\\company Oobly}\n"\
                   "{\\doccomm Joobly}\n"\
                   "#{to_rtf(info[4].created)}\n}",
                   info[4].to_rtf
      assert_equal "   {\\info\n   {\\title Title 5}\n"\
                   "   {\\author J. Bloggs}\n"\
                   "   {\\company }\n"\
                   "   {\\doccomm }\n"\
                   "   #{to_rtf(date)}\n   }",
                   info[5].to_rtf(3)
      assert_equal "{\\info\n{\\title Alternative Title}\n"\
                   "{\\author A. Person}\n"\
                   "{\\doccomm New information comment text.}\n"\
                   "#{to_rtf(date)}\n}",
                   info[6].to_rtf
   end

   def to_rtf(time)
      text = StringIO.new
      text << "{\\createim\\yr#{time.year}"
      text << "\\mo#{time.month}\\dy#{time.day}"
      text << "\\hr#{time.hour}\\min#{time.min}}"
      text.string
   end
end

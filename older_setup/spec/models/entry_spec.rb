require './entry'

describe Entry do
  describe '#to_html' do
    context 'with no frontmatter' do
      it 'returns the html for the entry' do
        allow(File).to receive(:read).and_return('haha')
        markdown = double(:markdown, render: '<p>haha</p>')
        html = Entry.new('filename', markdown).to_html
        expect(html).to eq '<article><h1>filename</h1><p>haha</p></article>'
      end
    end

    context 'with frontmatter' do
      it 'returns the html for the entry with tags' do
        allow(File).to receive(:read).and_return("tags: lol\n---\nhaha")
        markdown = double(:markdown, render: '<p>haha</p>')
        html = Entry.new('filename', markdown).to_html
        expect(html).to eq "<article><h1>filename</h1><p class='tags'><a href='lol'>lol</a></p><p>haha</p></article>"
      end
    end
  end
end

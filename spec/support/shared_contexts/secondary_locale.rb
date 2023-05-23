shared_context 'secondary locale' do
  let(:blog_page){ visit refinery.blog_root_path(locale: :ru)}
end

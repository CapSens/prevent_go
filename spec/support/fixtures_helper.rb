module FixturesHelper
  def test_file_path_for(file_name)
    "#{Gem::Specification.find_by_name("prevent_go").gem_dir}/spec/fixtures/#{file_name}"
  end
end

require "test_helper"

class SocialCardRendererTest < ActiveSupport::TestCase
  test "renders the shortest and longest current titles at Open Graph dimensions" do
    [ "Brexit", "Legalisation of controlled drugs in the United States" ].each do |title|
      image_data = SocialCardRenderer.new(title: title, site_key: "informed_opinion").render
      image = Vips::Image.new_from_buffer(image_data, "")

      assert_equal 1200, image.width
      assert_equal 630, image.height
      assert image_data.start_with?("\x89PNG".b)
    end
  end

  test "renders visually distinct cards for the two site identities" do
    io = SocialCardRenderer.new(title: "Brexit", site_key: "informed_opinion").render
    wyv = SocialCardRenderer.new(title: "Brexit", site_key: "whats_your_view").render

    assert_not_equal io, wyv
    assert_not_equal SocialCardRenderer.fingerprint("Brexit", "informed_opinion"),
      SocialCardRenderer.fingerprint("Brexit", "whats_your_view")
  end

  test "uses serif for IO and a warm neutral ground for What's Your View" do
    io_theme = SocialCardRenderer::THEMES.fetch("informed_opinion")
    wyv_theme = SocialCardRenderer::THEMES.fetch("whats_your_view")

    assert_equal "DejaVu Serif", io_theme.fetch(:title_font)
    assert_equal "DejaVu Sans", wyv_theme.fetch(:title_font)
    assert_equal "#fffaf2", wyv_theme.fetch(:background)
    assert_equal "#eee5d8", wyv_theme.fetch(:border)
  end

  test "changing a title changes the cache fingerprint" do
    before = SocialCardRenderer.fingerprint("Legalisation of drugs", "informed_opinion")
    after = SocialCardRenderer.fingerprint("Legalising drugs", "informed_opinion")

    assert_not_equal before, after
  end
end

class Api::V1::DocumentationController < Api::V1::BaseController
  def editorial_standard
    render json: {
      name: "Informed Opinion editorial standard",
      content: Rails.root.join("docs/editorial-standard.md").read
    }
  end
end

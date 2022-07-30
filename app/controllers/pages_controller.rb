class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def files
    @files = $drive.list_files
  end

  def fetch_file
    $drive.get_drive.export_file(
      params[:id],
      # mime_type: "application/vnd.oasis.opendocument.text",
      mime_type: "application/vnd.google-apps.document",
      download_dest: '/tmp/downloaded-test.txt')
    # @file = $drive.get(params[:id])
    byebug
  end
end

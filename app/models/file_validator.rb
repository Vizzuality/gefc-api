class FileValidator
  class FileValidatorException < StandardError; end

  class PathException < FileValidatorException; end

  class ExtensionException < FileValidatorException; end

  def initialize(file_path)
    @full_path = Rails.root.to_s + file_path
  end

  # Checks if file in full_path exists and if is a csv
  # Returns full file path
  #
  def path
    raise PathException.new("an error has ocurred:this file dont exist:#{@full_path}") unless File.file?(@full_path)
    raise ExtensionException.new("an error has ocurred:file is not a csv:#{@full_path}") unless File.extname(@full_path) == '.csv'
    @full_path
  end
end

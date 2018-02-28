RSpec.describe Metamorfose::Input::CSV do
  before :all do
    @csv_sample_data = csv = <<~CSV
      name,age
      foo,42
    CSV

    @sample_file = Tempfile.new 'sample_file.csv'

    @sample_file.write @csv_sample_data
    @sample_file.rewind
    @sample_file.close
  end

  after :all do
    @sample_file.unlink
  end

  it 'should reads the CSV file with headers' do
    options = { headers: true }
    expected_output = [{ 'name' => 'foo', 'age' => '42' }]

    run_etl filename: @sample_file.path, csv_options: options, expected_output: expected_output
  end

  it 'should reads a CSV file without headers' do
    expected_output = [['name', 'age'], ['foo', '42']]
    run_etl filename: @sample_file.path, expected_output: expected_output
  end

  def run_etl(filename:, csv_options: {}, expected_output:)
    test = self

    job = Kiba.parse do
      rows = []

      source Metamorfose::Input::CSV, filename: filename, csv_options: csv_options
      transform { |row| rows << row }

      post_process do
        test.expect(rows).to test.eq expected_output
      end
    end

    Kiba.run(job)
  end
end

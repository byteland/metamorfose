RSpec.describe Metamorfose::Output::CSV do
  before :all do
    @sample_file = Tempfile.new 'sample_file.csv'
    @sample_file.close
  end

  after :all do
    @sample_file.unlink
  end

  it 'should write the data to a CSV file' do
    output = run_etl filename: @sample_file.path

    expected_output = <<~CSV
      name,age
      bar,29
    CSV

    expect(output).to eq expected_output
  end

  it 'should write the data to a CSV file with provided options' do
    output = run_etl filename: @sample_file.path, csv_options: { col_sep: ';' }

    expected_output = <<~CSV
      name;age
      bar;29
    CSV

    expect(output).to eq expected_output
  end

  it 'should write only data from provided headers' do
    output = run_etl filename: @sample_file.path, headers: [:age]

    expected_output = <<~CSV
      age
      29
    CSV

    expect(output).to eq expected_output
  end

  private

  def run_etl(filename:, csv_options: nil, headers: nil)
    job = Kiba.parse do
      source Kiba::Common::Sources::Enumerable, [
        { name: 'bar', age: 29 }
      ]

      destination Metamorfose::Output::CSV,
        filename: filename,
        csv_options: csv_options,
        headers: headers
    end

    Kiba.run(job)

    IO.read(filename)
  end
end

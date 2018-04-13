RSpec.describe Metamorfose::Output::CSV do
  let(:csv_sample) do
    <<~CSV
      name,age
      bar,42
    CSV
  end

  before :each do
    @sample_file = Tempfile.new 'sample_file.csv'
    @sample_file.close
  end

  after :each do
    @sample_file.unlink
  end

  it 'should write the provided data to a CSV file' do
    settings = { filename: @sample_file.path }
    output = execute_etl(settings)

    expect(output).to eq csv_sample
  end

  it 'should write the data to a CSV file with provided options' do
    settings = { filename: @sample_file.path, col_sep: ';' }
    output = execute_etl(settings)

    expect(output).to eq csv_sample.gsub(',', ';')
  end

  it 'should write only data from provided headers' do
    settings = { filename: @sample_file.path, headers: [:age] }
    output = execute_etl(settings)

    expected_output = <<~CSV
      age
      42
    CSV

    expect(output).to eq expected_output
  end

  def execute_etl(settings)
    job = Kiba.parse do
      source Kiba::Common::Sources::Enumerable, [{ name: 'bar', age: '42' }]
      destination Metamorfose::Output::CSV, settings: settings
    end

    Kiba.run(job)
    IO.read(@sample_file.path)
  end
end

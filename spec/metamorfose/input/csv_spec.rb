RSpec.describe Metamorfose::Input::CSV do
  let(:filename) { File.join(Metamorfose.root_path, 'spec', 'support', 'sample.csv') }

  it 'should reads a CSV file with headers' do
    expected_output = [{ 'id' => '1', 'name' => 'foo', 'age' => '42' }]

    settings = { filename: filename, headers: true }
    rows = execute_etl(settings: settings)

    expect(rows).to eq expected_output
  end

  it 'should reads a CSV file without headers' do
    expected_output = [['id', 'name', 'age'], ['1', 'foo', '42']]

    settings = { filename: filename }
    rows = execute_etl(settings: settings)

    expect(rows).to eq expected_output
  end
end

def execute_etl(settings: {})
  output_rows = []

  job = Kiba.parse do
    source Metamorfose::Input::CSV, settings: settings
    transform { |row| output_rows << row }
  end

  Kiba.run(job)

  output_rows
end

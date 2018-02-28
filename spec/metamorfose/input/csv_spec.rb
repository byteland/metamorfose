RSpec.describe Metamorfose::Input::CSV do
  let(:default_csv_path) do
    Pathname.new(__FILE__).join('../../support/sample.csv')
  end

  let(:custom_col_sep_csv_path) do
    Pathname.new(__FILE__).join('../../support/custom_col_sep.csv')
  end

  it 'should successfully reads the CSV' do
    rows = csv_input filename: default_csv_path

    expect(rows.count).to eq 3
    expect(rows.first.count).to eq 4
  end

  it 'should successfully reads the CSV with a different column separator' do
    rows = csv_input filename: custom_col_sep_csv_path, col_sep: ';'

    expect(rows.count).to eq 3
    expect(rows.first.count).to eq 4
  end

  private

  def csv_input(settings = {})
    rows = []

    control = Kiba.parse do
      source Metamorfose::Input::CSV, settings

      transform do |row|
        rows << row
        row
      end
    end

    Kiba.run(control)

    rows
  end
end

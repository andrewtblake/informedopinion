namespace :fact_questions do
  namespace :calibration do
    desc "Export a non-destructive fact-question calibration worksheet (OUTPUT=path optional)"
    task export: :environment do
      content = JSON.pretty_generate(FactQuestionCalibrationAudit.new.worksheet)
      output = ENV["OUTPUT"].to_s.strip
      if output.present?
        File.write(output, "#{content}\n")
        puts "Exported calibration worksheet to #{output}."
      else
        puts content
      end
    end

    desc "Validate a completed calibration worksheet against the selected database (INPUT=path)"
    task validate: :environment do
      document = JSON.parse(File.read(ENV.fetch("INPUT")))
      FactQuestionCalibrationAudit.validate!(document)
      puts "Calibration worksheet is complete, valid and current."
    rescue FactQuestionCalibrationAudit::InvalidWorksheet => error
      abort error.message
    end

    desc "Report calibration distributions and gaps (INPUT=path optional)"
    task report: :environment do
      document = if ENV["INPUT"].present?
        JSON.parse(File.read(ENV.fetch("INPUT")))
      else
        FactQuestionCalibrationAudit.new.worksheet
      end
      puts JSON.pretty_generate(FactQuestionCalibrationAudit.report(document))
    end
  end
end

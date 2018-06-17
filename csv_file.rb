require 'csv'

module CSVFile
    # expects an array of arrays
    def self.columns_with_data(objects)
        csv_string = CSV.generate do |csv|
            objects.each do |object|
                csv << object
            end
        end
    end

    def self.save!(file_name, objects)
        CSV.open(file_name, "wb") do |csv|
            objects.each do |object|
                csv << object
            end
        end
    end
end
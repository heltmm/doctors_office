class Doctor
  attr_reader(:name, :specialty_id, :id)

  def initialize(doctor)
    @name = doctor.fetch(:name)
    @specialty_id = doctor.fetch(:specialty_id)
    @id = doctor.fetch(:id)
  end

  def self.all
    returned_doctors = DB.exec("SELECT * FROM doctors;")
    doctors = []
    returned_doctors.each do |doctor|
      name = doctor.fetch("name")
      specialty_id = doctor.fetch("specialty_id").to_i
      id = doctor.fetch("id").to_i
      doctors.push(Doctor.new({name: name, specialty_id: specialty_id, id: id}))
    end
    doctors
  end

  def save
    result = DB.exec("INSERT INTO doctors (name, specialty_id) VALUES ('#{@name}', '#{@specialty_id}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==(another_doctor)
    self.name().==(another_doctor.name).&(self.specialty_id().==(another_doctor.specialty_id())).&(self.id().==(another_doctor.id()))
  end

  def patients
    doctor_patients = []
    patients = DB.exec("SELECT * FROM patients WHERE doctor_id = #{self.id()};")
    patients.each() do |patient|
      name = patient.fetch("name")
      birthday = patient.fetch("birthday")
      doctor_id = patient.fetch("doctor_id").to_i
      id = patient.fetch("id").to_i
      doctor_patients.push(Patient.new({name: name, birthday: birthday, doctor_id: doctor_id, id: id}))
    end
    doctor_patients
  end

  def self.find(id)
    found_doctor = nil
    Doctor.all().each() do |doctor|
      if doctor.id().==(id)
        found_doctor = doctor
      end
    end
    found_doctor
  end
end

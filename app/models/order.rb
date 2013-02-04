class Order < ActiveRecord::Base

  belongs_to :user
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true

#  after_update :save_documents

  #проверка ассоциированных объектов------------------------------------------
    validates_associated :documents

  #обновление или добавление атрибутов ассоциированной модели-----------------
  def new_document_attributes=(document_attributes)
    document_attributes.each do |attributes|
      documents.build(attributes)
    end
  end

  def existing_document_attributes=(document_attributes)
    documents.reject(&:new_record?).each do |document|
      attributes = document_attributes[document.id.to_s] #берем ее атрибуты и записываем в переменную attributes
        if attributes[:docfile_delete] == "1"
           document.docfile.destroy
        end
    end
  end

  def save_documents
    documents.each do |document|
      document.save(false) #отключаем валидацию при сохранении
      if document.docfile_file_name == nil #удаляем все пустые записи без файлов в базе
        document.delete
      end
    end
  end

end

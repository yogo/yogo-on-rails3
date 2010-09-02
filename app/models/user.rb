require 'sentient_user'

class User

  include DataMapper::Resource
  include SentientUser
  include Facet::DataMapper::Resource
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # :registerable
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,  :timeoutable


  property :id, Serial
  property :login, String
  property :first_name, String
  property :last_name,  String
  
  property :created_at, DateTime
  property :created_on, Date

  property :updated_at, DateTime
  property :updated_on, Date

  has n, :memberships
  has n, :projects, :through => :memberships, :model => 'Yogo::Project'
  has n, :roles,    :through => :memberships
  belongs_to :system_role

  validates_confirmation_of :password
  
end

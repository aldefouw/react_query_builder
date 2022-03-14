class Person < ApplicationRecord

	enum status: {
		"Pending": 1,
		"Active": 2,
		"Terminated": 0
	}

end
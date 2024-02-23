.SILENT: test coverage
.PHONY:  test coverage

test:
	rspec -fd spec/
	echo "Finish ✅"

coverage:
	cov=true rspec -fd spec
	echo "Finish ✅"

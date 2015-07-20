shared_examples "a CmdItem"	do
	it { is_expected.to respond_to(:name) }
	it { is_expected.to respond_to(:name=) }
end

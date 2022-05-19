public with sharing class CustomSelectOption {

    String label {get;set;}
	String value {get;set;}

	public CustomSelectOption() {
		this.label = '';
		this.value = '';
	}

	public CustomSelectOption(String lab, String val) {
		this.label = lab;
		this.value = val;
	}
}

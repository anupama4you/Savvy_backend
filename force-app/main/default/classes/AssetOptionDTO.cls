public class AssetOptionDTO {
	@AuraEnabled
	public String code {set;get;}

	@AuraEnabled
	public String name {set;get;}

	@AuraEnabled
	public String typeOption {set;get;}

	@AuraEnabled
	public Decimal value {set;get;}

	public AssetOptionDTO(String typeOption) {
		this.typeOption = typeOption;
		this.value = 0.0;	
	}

	public AssetOptionDTO(String typeOption, String code) {
		this(typeOption);
		this.code = code;
	}

	public AssetOptionDTO(String typeOption, String code, Decimal value) {
		this(typeOption, code);
		this.value = value;
	}

	public static List<AssetOptionDTO> build(String typeOption, String data) {
		List<AssetOptionDTO> r = new List<AssetOptionDTO>();
		if (!String.isBlank(typeOption) && !String.isBlank(data)) {

			List<String> tmp = data.split(',');
			for (String s : tmp) {
				if (s.contains(':')) {
					String[] val = s.split(':');
					if (val[1].isNumeric()) {
						r.add(new AssetOptionDTO('Optional', val[0], Decimal.valueOf(val[1])));
					} else {
						r.add(new AssetOptionDTO('Optional', val[0]));
					}
				} else {
					r.add(new AssetOptionDTO('Standard', s));
				}
			}

		}
		return r;
	}

}
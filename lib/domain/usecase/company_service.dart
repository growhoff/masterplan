class CompanyService {
  int? companyId;

  static final CompanyService instance = CompanyService._internal();

  CompanyService._internal();

  factory CompanyService(int companyId) {
    instance.companyId = companyId;

    return instance;
  }
}
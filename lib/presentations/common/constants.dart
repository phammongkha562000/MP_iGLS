// ignore_for_file: constant_identifier_names

class SystemId {
  static const String iglsApp = "MB_IGLS";
  static const String iglsWebPortal = "WB_WP";
}

const systemId = 'MB_IGLS';
const systemIdWebPortal = "WB_WP";
//Admin account
const adminId = "NANGPHAM";

//case menu home
const caseDashboard = "/dashboard";
const casePlanTransfer = "/plantransfer";
const caseTaskHistory = "/taskhistory";
const caseDriverCheckIn = "/drivercheckin";
const caseDriverProfile = "/driverprofile";
const caseDriverSalary = "/payslip";

//Freight fowarding
const caseHaulageActivity = '/haulageactivity';
const caseCashCostAppoval = '/cashcostapproval';
const caseSiteStockCheck = '/sitestockcheck';
const caseTodoFreightForwarding = '/haulagetodo';
const caseSiteTrailer = '/sitetrailer';
const caseShipmentStatus = "/shipmentStatus";
//Error code
const errorNullEquipDriverId = 1;
const errorNullCheckIn = 2;
const errorNewVersion = 3;
const errorNotExits = 4;
const errorNoConnect = 2000;
const errorNoPermissionMb = 6;
const errorNoUpdateCNTR = 'ERR001';
const errorValidateFormatCNTR = 'ERR002';
const errorDefaultPass = 900;
const errorOldPass = 901; //"old_pass";
const errorCheckPass = 902; //"check_pass";
//* 18/03/202
const errDownloadAndGet = 1000;
const errStringDownloadAndGet = 'download_file_error';

//Local distribution
const caseToDoLocalDistribution = '/triptodo';
const caseHistoryTodo = "/historytodo";
const caseTripRecord = '/triprecord';
const casePickUpDelivery = '/selfpickupdelivery';
const caseLoadingStatus = '/loadingstatus'; //22/5/2023

//stock count
//orther
const caseDriverClosingHistory = '/driverclosinghis';
const caseManualDriverClosing = '/manualdriver';
const caseRepairRequest = '/repairrequest';
const caseSetting = "/setting";

//ware house
const caseInventory = "/inventory";
const caseGoodsReceipt = "/goodreceipt";
const caseRelocation = "/relocation";
const caseInboundPhoto = '/inboundphoto';
const caseStockCount = "/stockcount";
const casePutAway = '/putaway';
const casePicking = '/pickup';
const casePalletRelocation = '/palletrelocation';

const minuteComplete = 5;

//shuttletrip
const caseShuttleTrip = '/shuttletrip';
const caseAddNewSimpleTrip = '/newtriptodo';
const caseUpdateSimpleTrip = '/simpleupdate';

//packages
const caseReceiptPackage = '/receiptpackage';
const caseTransferPackage = '/transferpackage';
const caseReleasePackage = '/releasepackage';

//delivery status
const caseDeliveryStatus = '/deliverystatus';

//* MPi - timesheet, leave, clockinout
const caseMPiLeave = '/leave';
const caseMPiCheckInOut = '/checkinout';
const caseMPiTimesheet = '/timesheet';

//datetime parse
const ticksFormSinceEpoch = (621355968000000000 + 252000000000);
const toMilliseconds = 10000;
//url get image trailer no todohaulage
const urlGetImageTrailer = 'https://pro.igls.vn/uploads';
const pathLocal = 'D:\\LE\\DS_FILES\\S1';

/* 18/07/2024 */
const urlMPI = 'https://mpi.mplogistics.vn/uploads/';
//string error
const errorMessNewVersion = 'NewVersion';

//apiKey gg map
const apiKeyGGMap = 'AIzaSyAXiMLkRaq16MeTMVOFnYWqxDd0TCV3prU';

//29/06/2023
const takeFreqVisitPage = 10;

//datetime format
const formatMMddyyyy = 'MM/dd/yyyy';
const formatyyyMMdd = 'yyyy-MM-dd';
const formatMMddyyyyHHmm = 'MM/dd/yyyy HH:mm';
const formatyyyyMMdd = 'yyyyMMdd';
const formatddMMyyyy = 'dd/MM/yyyy';
const formatyyyyMMddHHmm = 'yyyy-MM-dd HH:mm';
const formatMMddyyyyHHmmss = 'MM/dd/yyyy HH:mm:ss';

const woTaskStatusStart = 'STARTED';

//06/07/2023
//staff
const caseStaffs = '/staff';
const caseEquipments = '/equipments';
const caseUsers = '/users';

const passwordDefault = '123456';
const errCodeInitLogin = 1007;
const errCodeBiometrics = 1008;
const errCodeNotAllowBiometrics = 1009;

const androidAppId = "com.mpl.mpigls";
const iOSAppId = "6444552090";

const defaultPass = "123456";
const modeCustomer = "CUSTOMER";
const modeDriver = "DRIVER";

//notification
const inboxRead = 'READ';
const inboxNotification = 'NOTIFICATION';
//customer
const caseCustomerOOS = 'outboundstatus';
const caseCustomerIOS = 'inboundstatus';
const caseCustomerInventory = 'inventory';
const caseCustomerTOS = 'transportorderstatus';
const caseTrackAndTrace = "trackandtrace";
const caseCNTRHaulage = "cntrhaulage";
const caseCNTRAgeing = "cntrageing";
const caseProfile = "profile";
const caseHaulageDaily = "haulagedaily";
const caseHaulageOverview = "haulageoverview";
const caseContact = "contact";
const caseCustomerBooing = "booking";
const caseTransportOverview = "transportoverview";

//disable
const caseDemDetStatus = "demdetstatus";
const caseVehicleTracking = "vehicletracking";
const caseTransportOverviewB = "transportoverviewb";
const caseShuttleOverview = "shuttleoverview";
const caseKpiDashboard = "kpidashboard";
const caseKpiScoreView = "kpiscoreview";
const caseFreightInvoices = "freightinvoices";
const caseCustomerTripRecord = "triprecord";
const caseOrderDetail = "orderdetail";
const caseOrders = "orders";
const caseEquipmentPhotos = "equipmentphotos";

//stdCode customer
const customerSTDOOS = 'OUTBOUNDDATESER';
const customerSTDOOSStatus = 'ORDSTATUS';
const customerSTDGrade = 'GRADE';
const customerSTDItemsStatus = 'ITEMSTATUS';
const customerSTDNotify = 'NOTIFY';
const customerSTDIOS = 'INBOUNDDATESER';

//stdcode driver
const driverSTDGrade = 'GRADE';
const driverSTDItemsStatus = 'ITEMSTATUS';

const companyName = 'MP LOGISTICS CORPORATION';

//store
const urlGooglePlay = "https://play.google.com/store/apps/details?id=";
const urlAppStore = "https://apps.apple.com/app/id";

//working status trailler
/* Code */
const traillerNORL = 'NORL';
const traillerNOTW = 'NOTW';
const traillerFORRENT = 'FORRENT';
/* Desc */
const traillerNormal = '5570';
const traillerNotWorking = '5571';
const traillerForRent = '5572';

const rd1Day = '5573';
const rd7Day = '5574';
const rd30Day = '5575';
const rd90Day = '5576';
const rdFRV = 'forever';

const appName = 'iGLS';

const sizePaging = 20; //20

//
const ddMMyyyy = 'ddMMyyyy';
const yyyyMMdd = 'yyyy/MM/dd';
const ddMMyyyySlash = 'dd/MM/yyyy';
const yyyyMMddHHmmssSlash = 'yyyy/MM/dd HH:mm:ss';



const authen = 'WCFRestAuthentication.svc/ValidateUserIdPwd';
const register = "/api/userprofile/registrationaccount";
const menuHome =
    'MB2/MbSvc2.svc/PageMenuPermission?uid=%s&systemId=%s&subsidiaryId=%s';

const updateTimeWithDetailItem =
    "MB2/MbSvc2.svc/UpdateWorkOrderEquipTaskMobile?strCompany=%s";

const saveAvailableEquipmnentCheckIn =
    "MB2/MbSvc2.svc/SaveAvailableEquipmnentCheckIn?companyId=%s";
const getHaulageTodoList =
    "MB2/MbSvc2.svc/GetHaulageToDoListForMobile?companyId=%s";
const getImageTodoHaulage =
    "/WP/WPRestFullSvc.svc/GetUploadedDocuments?RefNoValue=%s&DocRefType=%s&RefNoType=%s&strCompany=%s";
const getDriverToday =
    "/MB2/MbSvc2.svc/GetDriverToday?equipmentCode=%s&driverId=%s&companyId=%s";
const getHaulageTodoByIdForMobile =
    "/MB2/MbSvc2.svc/GetHaulageToDoForMobile?wOTaskId=%s&companyId=%s";
const updateWorkOrderStatus =
    "/MB2/MbSvc2.svc/SaveWorkOrderStatus?companyId=%s";
const updateWorkOrderTrailer =
    "MB2/MbSvc2.svc/UpdateWorkOrderTrailer?companyId=%s";
const updateWOEquipTaskDriverMemo =
    "MB2/MbSvc2.svc/UpdateWOEquipTaskDriverMemo?strCompany=%s";
const updateContainerAndSealNo =
    "/MB2/MbSvc2.svc/UpdateContainerAndSealNo?companyId=%s";
const getUploadedDocuments =
    "MB2/MbSvc2.svc/GetUploadedDocuments?RefNoValue=%s&DocRefType=%s&RefNoType=%s&strCompany=%s";
const uploadDocument = "MB2/MbSvc2.svc/UploadDocument?subsidiaryId=%s";
const getShipmentStatus =
    "/MB2/MbSvc2.svc/GetShipmentStatusForMobile?subsidiary=%s";
const getShipmentStatusDetail =
    "MB2/MbSvc2.svc/GetEquipTaskByWONoForMobile?woNo=%s&cntrNo=%s&itemNo=%s&subsidiary=%s";
//History
const getTaskHistory = "MB2/MbSvc2.svc/GetDailyTasksForDriver?companyId=%s";
const getHistoryDetail =
    "MB2/MbSvc2.svc/GetDailyTaskForDriver?dtId=%s&companyId=%s";
const getHistoryDetailItem =
    "MB2/MbSvc2.svc/GetDailyTaskDetailItem?dtdId=%s&strCompany=%s";
const getEquipment = "MB2/MbSvc2.svc/GetEquipments2?companyId=%s";
const checkEquipment = "/MB2/MbSvc2.svc/CheckTrailer?companyId=%s";
const getEquipment3 = "/MB2/MbSvc2.svc/GetEquipments3?strCompany=%s";

const getTripTodo = '/MB2/MbSvc2.svc/GetTripTodoForMobile';

//# ?driverId=%s&etp=%s&companyId=%s&equipmentCode=%s

const getSimpleTripDetail =
    "/MB2/MbSvc2.svc/GetSimpleTripDetail?tripNo=%s&companyId=%s";
const updateSimpleTripStatus =
    "/MB2/MbSvc2.svc/UpdateSimpleTripForMobile?contactCode=%s&companyId=%s";
const getStdCodes = "/MB2/MbSvc2.svc/GetStdCodes?stdCode=%s&subsidiaryId=%s";
const urlGoogleMap =
    "https://maps.googleapis.com/maps/api/directions/%s?%s&key=%s";
const urlCheckListToDoTrip =
    "Webbrowser/Inspection.aspx?DriverId=%s&EquipmentCode=%s&ShipmentNo=%s&CreateUser=%s";
const getNormalTripForMobile =
    "/MB2/MbSvc2.svc/GetTripForMobile?strTripNo=%s&strDCCode=%s&strCompany=%s";

const updateNormalTripStatus = "/MB2/MbSvc2.svc/SaveTripStatus?subsidiaryId=%s";
const updateNormalTripOrgItemStatus =
    "/MB2/MbSvc2.svc/SaveTripStepWithTOrgItemNo";
const addStockCount = "/MB2/MbSvc2.svc/SaveStockCount";
const getStockCount = "/MB2/MbSvc2.svc/GetStockCount";
const getLocation =
    "/MB2/MbSvc2.svc/GetLocations?dcCode=%s&locRole=%s&subsidiaryId=%s";
const deleteStockCount = "/MB2/MbSvc2.svc/DeleteStockCount";
const getItemCode =
    "/MB2/MbSvc2.svc/GetItems?contactCode=%s&dcCode=%s&modelCode=%s&subsidiaryId=%s";

const getHistoryTodo = "/MB2/MbSvc2.svc/GetHistoryToDoList?companyId=%s";
const getNormalTripDetail =
    "/MB2/MbSvc2.svc/GetTripDetail?tripNo=%s&dcNo=%s&subsidiaryId=%s";

//site stock check
const getCYSite = "MB2/MbSvc2.svc/GetCYSite?companyId=%s";
const getTrailerStock = "MB2/MbSvc2.svc/GetTrailerStock?companyId=%s";
const getSaveSiteStockCheck = "/MB2/MbSvc2.svc/SaveSiteStockCheck?companyId=%s";

/* 11/07/2024 */
const getSiteStockCheckSummary =
    'MB2/MbSvc2.svc/GetTrailerStockSummary?companyId=%s';
const deleteSiteStockCheck = '/MB2/MbSvc2.svc/DeleteTrailerStock?companyId=%s';
const getSiteStockCheckPending =
    '/MB2/MbSvc2.svc/GetTrailerStockViewPending?companyId=%s';

//setting
const getLocalPermissionForUserProfile =
    "/MB2/MbSvc2.svc/GetLocalAccessPermisson?uid=%s&subsidiaryId=%s";
const updateUserProfile = "/MB2/MbSvc2.svc/UpdateUserProfile?subsidiary=%s";

//ware house
const getOrderDetailForGR = "/MB2/MbSvc2.svc/GetOrderDetailForGr";
const getOrdersForGR = "/MB2/MbSvc2.svc/GetOrdersForGr";
const getOrdersForInboundImage = "MB2/MbSvc2.svc/GetOrdersForGRInboundPhoto";
const getTrailer = "/MB2/MbSvc2.svc/GetTrailers?companyId=%s";
const getSaveSiteTrailer = "MB2/MbSvc2.svc/SaveSiteTrailer?companyId=%s";
const getInventory = "/MB2/MbSvc2.svc/GetInventory";
const getInventoryDetail = "/MB2/MbSvc2.svc/GetInventoryBaseOnItem";
const getTrailerPending =
    "/MB2/MbSvc2.svc/GetTrailerViewPending?isPending=%s&dateCheck=&branchCode=%s&companyId=%s";
const getTrailerSumary = "MB2/MbSvc2.svc/GetTrailerSummary?companyId=%s";

//cash cost appoval
const getBulkCostApproval = "MB2/MbSvc2.svc/GetBulkCostApproval?strCompany=%s";
const getSaveBulkCostApproval =
    "MB2/MbSvc2.svc/SaveBulkCostApproval?strCompany=%s";

//relocation
const getRelocation = "/MB2/MbSvc2.svc/GetRelocationPlans?strCompany=%s";
const getSaveRelocation = "/MB2/MbSvc2.svc/UpdateRelocationPlan?strCompany=%s";

//goood receipt
const getContactStdCode =
    'MB2/MbSvc2.svc/GetContactStdCodes?StdCodeType=%s&CodeVariant=%s&ContactCode=%s&Subsidiary=%s';
const getSku = "/MB2/MbSvc2.svc/GetItem2SKUOrderByItem?iorderId=%s&subId=%s";
const getSaveGRs = "MB2/MbSvc2.svc/SaveGRs?subsidiaryId=%s";

//other
const changePass = "/MB2/MbSvc2.svc/UpdatePassword?strCompany=%s";
//manual driver closing
const getSaveDriverDailyClosingWithoutTripNo =
    "/MB2/MbSvc2.svc/SaveDriverDailyClosingWithoutTripNo?companyId=%s";
const getSaveDriverDailyClosingWithTripNo =
    "/MB2/MbSvc2.svc/SaveDriverDailyClosingWithTripNo?companyId=%s";
//12/03/2024
const updateDriverDailyClosing =
    'MB2/MbSvc2.svc/UpdateDriverDailyClosing?strCompany=%s';

const getDriverDailyClosings = "/MB2/MbSvc2.svc/GetDriverDailyClosings";
const getDriverDailyClosing =
    "/MB2/MbSvc2.svc/GetDriverDailyClosing?ddcId=%s&companyId=%s";
const getContactByUserId = "MB2/MbSvc2.svc/GetContacts?strCompany=%s&userId=%s";
const getDriverContactUsedFreq =
    "MB2/MbSvc2.svc/GetDriverContactUsedFreq?equipmentCode=%s&dcCode=%s&strCompany=%s";
const updateSimpleTripMyWork =
    "MB2/MbSvc2.svc/UpdateSimpleTripMyWork?&companyId=%s";
const saveSimpleTripForMobile2 =
    "MB2/MbSvc2.svc/SaveSimpleTrip?contactCode=%s&companyId=%s";
const getContactFormatNumber =
    "/MB2/MbSvc2.svc/GetContactOtherCode?contactCode=%s&subsidiary=%s";

//repair request
const saveRepairRequest = "MB2/MbSvc2.svc/SaveRepartRequest?companyId=%s";

//getStaff profile
const getStaffDetail =
    "MB2/MbSvc2.svc/GetStaffDetail?staffId=%s&subsidiaryId=%s";

//announcement
const getAnnouncementsForMobile =
    "MB2/MbSvc2.svc/GetAnnouncementsForMobile?userId=%s&branchCode=%s&dcCode=%s&strCompany=%s";
const getDetailAnnouncementForMobile =
    "MB2/MbSvc2.svc/GetAnnouncementForMobile?annId=%s&strCompany=%s";
const saveAnnouncementEndorse =
    "MB2/MbSvc2.svc/SaveAnnouncementEndorse?strCompany=%s";

//plan transfer
const updateWorkOrderEquipAssignTask =
    "MB2/MbSvc2.svc/UpdateWorkOrderEquipAssignTask?strCompany=%s";

//shuutle trip
const getShuttleTrips = "/MB2/MbSvc2.svc/GetShuttleTrips?strCompany=%s";
const saveAddShuttleTrip = "/MB2/MbSvc2.svc/SaveShuttleTrips?strCompany=%s";
const updateShuttleTrip = "/MB2/MbSvc2.svc/UpdateShuttleTrips?strCompany=%s";
const deleleShuttleTrip = "/MB2/MbSvc2.svc/DeleteShuttleTrip?strCompany=%s";

const getCompanysbyType =
    "/WP/WPRestFullSvc.svc/GetCompanysbyType?strCompany=%s";
const getCompanysFreq =
    "/MB2/MbSvc2.svc/GetDriverCompanyUsedFreq?strCompany=%s";

//pallet relocation
const getGRForRelocation =
    "MB2/MbSvc2.svc/GetGRForRelocation?grNo=%s&dcNo=%s&contactCode=%s&subsidiaryId=%s";

const saveGrForRelocation = "MB2/MbSvc2.svc/SaveGRForRelocation";

//last version
const getLatestVersion = "MB2/MbSvc2.svc/GetLatestVersion?SystemId=%s";
// *10/03/2023 DriverSalary
const getFileForDriverSalary = "api/payrollservice/emppayrollinyear/%s";

//16/03 Delivery status
const getDeliveryStatus =
    "/MB2/MbSvc2.svc/TruckDashboard?ContactCode=%s&DCCODE=%s&strCompany=%s";

//24/05/2023 Loading Status
const getLoadingStatus =
    '/MB2/MbSvc2.svc/GetListTripsLoadingStatus?strCompany=%s';

const saveLoadingStatus = '/MB2/MbSvc2.svc/SaveTripLoadingStatus?strCompany=%s';
const deleteLoadingStatus =
    '/MB2/MbSvc2.svc/DeleteTripLoadingStatus?TripNo=%s&strCompany=%s';

const getFreqVisitPage =
    '/MB2/MbSvc2.svc/GetFrequentVisitPage?userId=%s&language=%s&systemId=%s';
const saveFreqVisitPage = '/MB2/MbSvc2.svc/SaveFrequentVisitPage';

/* 06/07/2023 */
//staffs
const getStaffs = '/MB2/MbSvc2.svc/GetStaffs?subsidiary=%s';
const getStaffDetailByUserId =
    '/MB2/MbSvc2.svc/GetStaffDetailByStaffUserId?staffUserId=%s&strCompany=%s';
const getVendors = '/MB2/MbSvc2.svc/GetContactMPI?strCompany=%s';
const updateStaff = '/MB2/MbSvc2.svc/UpdateStaff?strCompany=%s';

//users
const getUsers =
    '/MB2/MbSvc2.svc/GetAllUsers?userid=%s&subsidiary=%s&isdeleted=%s';
const getUserDetail = '/MB2/MbSvc2.svc/GetUserProfile?userid=%s';
const getStdCode2 = '/MB2/MbSvc2.svc/GetStdCode?codeGroup=%s';
const updateUser = '/MB2/MbSvc2.svc/UpdateUserProfiles';
const copyUser = '/MB2/MbSvc2.svc/UsersCopy?strCompany=%s';
const resetPWDUser = '/MB2/MbSvc2.svc/ResetPasswordUser?strCompany=%s';
const activeUser =
    '/MB2/MbSvc2.svc/ActiveUser?userid=%s&updateuser=%s&strCompany=%s';

//equipments
const getEquipmentsAdmin = '/MB2/MbSvc2.svc/GetEquipmentMB?strCompany=%s';
const getEquipmentDetailAdmin =
    '/MB2/MbSvc2.svc/GetEquipmentDetailMB?strEquipmentCode=%s&strCompany=%s';
const updateEquipment = '/MB2/MbSvc2.svc/UpdateEquipment?strCompany=%s';
const getEquipmentType =
    '/MB2/MbSvc2.svc/GetEquipmentTypes?strEquipTypeNo=%s&strEquipTypeDesc=%s&strCompany=%s';

//14/06/2024 - Paging-lazyload
const String getNotification = "api/GetMessage/%s/%s/%s/%s/%s";
const String deleteNotifications = "/api/DeleteNotifi";

///30/08/2023
const String updateStatusNotification = "api/UpdateMsgStatus";
const String getTotalNotifications = "api/CountMessageByUser/%s/%s";

const String loginHub = "api/UserLogin";
const String logoutHub = "api/UserLogout";

//23/11 - Refresh token
const String revokeToken = 'WCFRestAuthentication.svc/revokeToken';

///Customer
///
const String customerLogin =
    'WCFRestAuthentication.svc/Authentication?isApiLogin=YES&isApiLogin=YES';
const String customerPermission =
    'WP/WPRestFullSvc.svc/UsersAccessPermission?userid=%s&lan=%s&sysid=%s';
const String getOsToday =
    "WP/WPRestFullSvc.svc/OS_GetToday?subsidiary=%s&contactCode=%s&dcCode=%s";

const String customerGetOOS =
    "WP/WPRestFullSvc.svc//GetOutboundOrder?strCompany=%s";
const String customerOOSDetail =
    'WP/WPRestFullSvc.svc//GetOutboundOrderDetail?orderid=%s&strCompany=%s';
const String customerGetInboundOrder =
    "WP/WPRestFullSvc.svc/GetInboundOrder?strCompany=%s";
const String customerGetIOSDetail =
    "WP/WPRestFullSvc.svc/GetInboundOrderDetail?orderid=%s&strCompany=%s";
const String customerStdCode =
    "WP/WPRestFullSvc.svc/GetStdCodes?StdCodeType=%s&Subsidiary=%s";
const String customerDownloadFile =
    "WP/WPRestFullSvc.svc/DownloadFileStream?docNo=%s&strCompany=%s";
const String customerTrackTraceStatus =
    "WP/WPRestFullSvc.svc/GetTrackingStatus?updateBased=%s&strCompany=%s";
const String customerGetUnloc = "WP/WPRestFullSvc.svc/GetUnloc?unLocCode=%s";
const String customerGetTrackAndTrace =
    "WP/WPRestFullSvc.svc/GetTrackAndTraces?strCompany=%s";
const String customerGetInventory =
    'WP/WPRestFullSvc.svc/GetInventories?Subsidiary=%s';
const String customerGetInventoryTotal =
    'WP/WPRestFullSvc.svc/GetInventorysIsTotal?Subsidiary=%s';
const String customerGetCntrHaulage =
    "WP/WPRestFullSvc.svc/GetFECNTRHaulage?strCompany=%s";

const String customerGetDetailCntrHaulage =
    "WP/WPRestFullSvc.svc/GetWOCNTRManifests?woNo=%s&woItemNo=%s&subsidiaryId=%s";
const String customerGetNotifyCntr =
    "WP/WPRestFullSvc.svc/GetNotifyCNTR?&subsidiaryId=%s";
const String customerSaveNotifySetting =
    "WP/WPRestFullSvc.svc/SaveNotifyCNTRs?subsidiaryId=%s";
const String customerDelNotifySetting =
    "WP/WPRestFullSvc.svc/DeleteNotifyCNTR?WONo=%s&ItemNo=%s&UserID=%s&subsidiaryId=%s";
const String customerContactStd =
    'WP/WPRestFullSvc.svc/GetContactStdCodes?StdCodeType=%s&CodeVariant=&ContactCode=%s&Subsidiary=%s';
const String customerCompany =
    'WP/WPRestFullSvc.svc/GetCompanysbyType?strCompany=%s';

const String customerTOS =
    'WP/WPRestFullSvc.svc/GetTransportOrderStatusForWp?subsiduaryId=%s';

const String customerTOSDetail =
    'WP/WPRestFullSvc.svc/GetTransportOrderDetailForWP?&strCompany=%s&contactCode=%s';

const String customerGetWoCntrAgeing =
    'WP/WPRestFullSvc.svc/GetWOCNTRAgeing?subsidiaryId=%s';
const String customerUpdateProfile = "WP/WPRestFullSvc.svc/UpdateWPUser";
const String customerNotifyOrder =
    'WP/WPRestFullSvc.svc/GetNotifyOrder?&subsidiaryId=%s';
const String customerSaveNotifyOrder =
    'WP/WPRestFullSvc.svc/SaveNotifyOrder?subsidiaryId=%s';
const String customerDeleteNotifyOrder =
    'WP/WPRestFullSvc.svc/DeleteNotifyOrder?TripNo=%s&OrderId=%s&UserID=%s&subsidiaryId=%s';
const String customerHaulageDaily = 'WP/WPRestFullSvc.svc/GetHaulageDashboard';
const String customerChangePass =
    "WP/WPRestFullSvc.svc/ResetPasswordWP?userid=%s&password=%s&systemId=%s";
const String customerHaulageOverview =
    'WP/WPRestFullSvc.svc/TEGetHaulageOverview';
const String customerTimeLine = "WP/WPRestFullSvc.svc/GetUserLogin?UserID=%s";
const String customerSubsidiary =
    "WP/WPRestFullSvc.svc/GetSubsidiaryInfo?subsidiaryId=%s";

//02/01/2024
const String deleteSiteTrailer =
    'MB2/MbSvc2.svc/DeleteTrailerList?strCompany=%s';

//forgot password -- web view
const String forgotPasswordMB = 'login/forgotpasswordmb?username=';
const String forgotPasswordWP = 'login/forgotpassword?username=';
const String siteTrailerHistory =
    'MB2/MbSvc2.svc/GetTrailerViewHistory?trailerNumber=%s&companyId=%s';

//customer - booking
const String customerGetBooking =
    '/WP/WPRestFullSvc.svc/GetBookingsForWP?strCompany=%s';

//customer - transport overview
const String customerGetTransportOverview =
    '/WP/WPRestFullSvc.svc/TEGetTranstportOverView';
const String customerGetShuttleOverview =
    '/MB2/MbSvc2.svc/GetShuttleOverview?Date=%s&contactCode=%s&dCCode=%s&strCompany=%s';

/* 25/04/2024 - Put Away */
const String getOrderType =
    'WP/WPRestFullSvc.svc/GetOrderTypes?OrderType=%s&ContactCode=%s&Subsidiary=%s';
const String getOrderForPW = '/MB2/MbSvc2.svc/GetOrdersForPW';
const String savePW = '/MB2/MbSvc2.svc/SavePWs?subsidiaryId=%s';

//09/05/2024 - Picking
const String getOrderForPick = '/MB2/MbSvc2.svc/GetOrdersForPick';
const String getFinalGrNo = '/MB2/MbSvc2.svc/GetFinalGRNo?grNo=%s&companyId=%s';
const String savePicking = '/MB2/MbSvc2.svc/SavePickOrder';

//24/05/2024 - Barcode GR tracking
const String getBarcodeGRTracking =
    '/MB2/MbSvc2.svc/GetGRTracking?grno=%s&companyId=%s';
//03/07/2024 - HA Transaction Report
const String getTransactionReport =
    '/MB2/MbSvc2.svc/GetCashStaffTransaction?strCompany=%s';

//09/10/2024 - MPi
const String getcoworklocs = "api/mpi/coworklocservice/coworklocs";

const String putTimeSheetService = "api/mpi/timesheetservice/timesheet";
const String getTimeSheetService = "api/timesheetservice/timesheets";
const String mpiGetStdcode = "api/mpi/commonservice/stdcodes/%s";
const String postCheckInOut = "api/timesheetservice/checkinoutapps";

const String getLeave = "api/leaveservice/leaves";
const String getLeaveDetail = "api/leaveservice/leave/23/lvid/%s/%s";
const String checkLeaveWithType = "api/leaveservice/leaveentitle/seach";
const String getWorkFlow =
    "api/mpi/documentservice/document/getdocumentworkflow";
const String createNewLeave = "api/leaveservice/save";

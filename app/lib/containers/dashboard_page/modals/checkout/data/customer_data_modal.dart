import 'package:excerbuys/components/input_with_icon.dart';
import 'package:excerbuys/components/shared/buttons/main_button.dart';
import 'package:excerbuys/components/shared/indicators/checkbox_with_label.dart';
import 'package:excerbuys/store/controllers/layout_controller/layout_controller.dart';
import 'package:excerbuys/store/controllers/shop/checkout_controller/checkout_controller.dart';
import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/shop/checkout.dart';
import 'package:excerbuys/types/shop/delivery.dart';
import 'package:excerbuys/utils/constants.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/shop/checkout/formatters.dart';
import 'package:excerbuys/utils/shop/checkout/utils.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:excerbuys/wrappers/modal/modal_content_wrapper.dart';
import 'package:flutter/material.dart';

class CustomerDataModal extends StatefulWidget {
  final void Function() prevPage;
  final void Function() nextPage;
  const CustomerDataModal(
      {super.key, required this.prevPage, required this.nextPage});

  @override
  State<CustomerDataModal> createState() => _CustomerDataModalState();
}

class _CustomerDataModalState extends State<CustomerDataModal> {
  final TextEditingController cityInputController = TextEditingController();

  bool? isInvoice = false;
  final Map<USER_DATA_INPUTS, String> _formFieldsState = {
    for (var key in USER_DATA_INPUTS.values) key: '',
  };
  final Map<USER_DATA_INPUTS, String> _formInitialsState = {
    for (var key in USER_DATA_INPUTS.values) key: '',
  };
  Map<USER_DATA_INPUTS, String?> _formErrorsState = {
    for (var key in USER_DATA_INPUTS.values) key: '',
  };

  String? _getErrorForField(USER_DATA_INPUTS key, String value) {
    if (value.isEmpty) return 'Field cannot be empty';

    switch (key) {
      case USER_DATA_INPUTS.EMAIL:
        if (!EMAIL_REGEX.hasMatch(value)) return 'Invalid email format';
        break;

      case USER_DATA_INPUTS.PHONE_NUMBER:
        if (!PHONE_REGEX.hasMatch(value)) return 'Invalid phone number';
        break;

      case USER_DATA_INPUTS.POST_CODE:
        if (!POST_CODE_REGEX.hasMatch(value)) return 'Invalid post code';
        break;

      case USER_DATA_INPUTS.NIP:
        if (isInvoice == true && !isValidNIP(value)) {
          return 'Invalid NIP number';
        }
        break;

      default:
        break;
    }

    return null;
  }

  bool _shouldValidate(USER_DATA_INPUTS key) {
    if (key == USER_DATA_INPUTS.FLAT_NUMBER) {
      return false; // Flat number is always optional
    }

    if ((key == USER_DATA_INPUTS.COMPANY_NAME || key == USER_DATA_INPUTS.NIP) &&
        isInvoice != true) {
      return false;
    }
    return true;
  }

  void setErrors() {
    setState(() {
      _formErrorsState = {
        for (final entry in _formFieldsState.entries)
          if (_shouldValidate(entry.key))
            entry.key: _getErrorForField(entry.key, entry.value.trim())
      };
    });
  }

  void preloadInputs() async {
    await checkoutController.loadUserOrderDataFromStorage();

// preload inputs data form previous completion
    final IUserOrderData? userOrderData = checkoutController.userOrderData;
    print(userOrderData?.firstName);
    if (userOrderData != null) {
      _formInitialsState[USER_DATA_INPUTS.NAME] = userOrderData.firstName;
      _formInitialsState[USER_DATA_INPUTS.SURNAME] = userOrderData.lastName;
      _formInitialsState[USER_DATA_INPUTS.EMAIL] = userOrderData.email;
      _formInitialsState[USER_DATA_INPUTS.PHONE_NUMBER] =
          userOrderData.phoneNumber;
      _formInitialsState[USER_DATA_INPUTS.STREET] =
          userOrderData.address.street;
      _formInitialsState[USER_DATA_INPUTS.POST_CODE] =
          userOrderData.address.postCode;
      _formInitialsState[USER_DATA_INPUTS.CITY] = userOrderData.address.city;
      _formInitialsState[USER_DATA_INPUTS.HOUSE_NUMBER] =
          userOrderData.address.houseNumber ?? '';
      _formInitialsState[USER_DATA_INPUTS.FLAT_NUMBER] =
          userOrderData.address.flatNumber ?? '';
      if (userOrderData.companyData != null) {
        isInvoice = true;
        _formInitialsState[USER_DATA_INPUTS.COMPANY_NAME] =
            userOrderData.companyData?.name ?? '';
        _formInitialsState[USER_DATA_INPUTS.NIP] =
            userOrderData.companyData?.nip ?? '';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    preloadInputs();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return StreamBuilder<List<ICartItem>>(
        stream: checkoutController.cartItemsStream,
        builder: (context, snapshot) {
          return ModalContentWrapper(
            title: 'Twoje dane',
            subtitle: 'Podaj dane do zamowienia',
            onClose: () {
              closeModal(context);
            },
            padding: EdgeInsets.only(
                left: HORIZOTAL_PADDING,
                right: HORIZOTAL_PADDING,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    layoutController.bottomPadding +
                    16),
            onClickBack: widget.prevPage,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 16,
                        children: [
                          Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dane ogólne',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colors.tertiary)),
                              Text(
                                  'Uzupełnij dane na podstawie których będzie moliwość wystawienia zamowienia',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: colors.tertiaryContainer)),
                            ],
                          ),
                          Container(
                            height: 0.1,
                            color: colors.tertiary,
                          ),
                          InputWithIcon(
                            placeholder: 'Imię *',
                            initialValue:
                                _formInitialsState[USER_DATA_INPUTS.NAME],
                            onChange: (e) {
                              setState(() {
                                _formFieldsState[USER_DATA_INPUTS.NAME] =
                                    e.trim();
                                _formErrorsState[USER_DATA_INPUTS.NAME] = '';
                              });
                            },
                            outsideLabel: 'Imię',
                            error: _formErrorsState[USER_DATA_INPUTS.NAME],
                            verticalPadding: 12,
                            borderRadius: 10,
                          ),
                          InputWithIcon(
                            placeholder: 'Nazwisko *',
                            initialValue:
                                _formInitialsState[USER_DATA_INPUTS.SURNAME],
                            onChange: (e) {
                              setState(() {
                                _formFieldsState[USER_DATA_INPUTS.SURNAME] =
                                    e.trim();
                                _formErrorsState[USER_DATA_INPUTS.SURNAME] = '';
                              });
                            },
                            outsideLabel: 'Nazwisko',
                            error: _formErrorsState[USER_DATA_INPUTS.SURNAME],
                            verticalPadding: 12,
                            borderRadius: 10,
                          ),
                          InputWithIcon(
                            placeholder: 'E-mail *',
                            initialValue:
                                _formInitialsState[USER_DATA_INPUTS.EMAIL],
                            onChange: (e) {
                              setState(() {
                                _formFieldsState[USER_DATA_INPUTS.EMAIL] =
                                    e.trim();
                                _formErrorsState[USER_DATA_INPUTS.EMAIL] = '';
                              });
                            },
                            outsideLabel: 'Email',
                            error: _formErrorsState[USER_DATA_INPUTS.EMAIL],
                            verticalPadding: 12,
                            borderRadius: 10,
                          ),
                          InputWithIcon(
                            inputType: TextInputType.number,
                            initialValue: _formInitialsState[
                                USER_DATA_INPUTS.PHONE_NUMBER],
                            inputFormatters: [PhoneNumberInputFormatter()],
                            placeholder: 'Numer telefonu *',
                            onChange: (e) {
                              setState(() {
                                _formFieldsState[
                                    USER_DATA_INPUTS.PHONE_NUMBER] = e.trim();
                                _formErrorsState[
                                    USER_DATA_INPUTS.PHONE_NUMBER] = '';
                              });
                            },
                            outsideLabel: 'Numer telefonu',
                            error:
                                _formErrorsState[USER_DATA_INPUTS.PHONE_NUMBER],
                            verticalPadding: 12,
                            borderRadius: 10,
                          ),
                          InputWithIcon(
                            placeholder: 'Ulica *',
                            initialValue:
                                _formInitialsState[USER_DATA_INPUTS.STREET],
                            onChange: (e) {
                              setState(() {
                                _formFieldsState[USER_DATA_INPUTS.STREET] =
                                    e.trim();
                                _formErrorsState[USER_DATA_INPUTS.STREET] = '';
                              });
                            },
                            outsideLabel: 'Ulica',
                            error: _formErrorsState[USER_DATA_INPUTS.STREET],
                            verticalPadding: 12,
                            borderRadius: 10,
                          ),
                          Row(
                            spacing: 16,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: InputWithIcon(
                                  placeholder: 'Numer domu *',
                                  initialValue: _formInitialsState[
                                      USER_DATA_INPUTS.HOUSE_NUMBER],
                                  onChange: (e) {
                                    setState(() {
                                      _formFieldsState[USER_DATA_INPUTS
                                          .HOUSE_NUMBER] = e.trim();
                                      _formErrorsState[
                                          USER_DATA_INPUTS.HOUSE_NUMBER] = '';
                                    });
                                  },
                                  outsideLabel: 'Numer domu',
                                  error: _formErrorsState[
                                      USER_DATA_INPUTS.HOUSE_NUMBER],
                                  verticalPadding: 12,
                                  borderRadius: 10,
                                ),
                              ),
                              Expanded(
                                child: InputWithIcon(
                                  placeholder: 'Numer lokalu',
                                  initialValue: _formInitialsState[
                                      USER_DATA_INPUTS.FLAT_NUMBER],
                                  onChange: (e) {
                                    setState(() {
                                      _formFieldsState[USER_DATA_INPUTS
                                          .FLAT_NUMBER] = e.trim();
                                      _formErrorsState[
                                          USER_DATA_INPUTS.FLAT_NUMBER] = '';
                                    });
                                  },
                                  outsideLabel: 'Numer lokalu',
                                  error: _formErrorsState[
                                      USER_DATA_INPUTS.FLAT_NUMBER],
                                  verticalPadding: 12,
                                  borderRadius: 10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: InputWithIcon(
                                  placeholder: 'Kod pocztowy *',
                                  initialValue: _formInitialsState[
                                      USER_DATA_INPUTS.POST_CODE],
                                  inputFormatters: [PostCodeInputFormatter()],
                                  inputType: TextInputType.number,
                                  onChange: (e) async {
                                    if (POST_CODE_REGEX.hasMatch(e) == true) {
                                      final city = await getCityForPostCode(e);
                                      if (city != null && city.isNotEmpty) {
                                        cityInputController.text = city;
                                        _formFieldsState[
                                            USER_DATA_INPUTS.CITY] = city;
                                        _formErrorsState[
                                            USER_DATA_INPUTS.CITY] = '';
                                      }
                                    }

                                    setState(() {
                                      _formFieldsState[USER_DATA_INPUTS
                                          .POST_CODE] = e.trim();
                                      _formErrorsState[
                                          USER_DATA_INPUTS.POST_CODE] = '';
                                    });
                                  },
                                  error: _formErrorsState[
                                      USER_DATA_INPUTS.POST_CODE],
                                  outsideLabel: 'Kod pocztowy',
                                  verticalPadding: 12,
                                  borderRadius: 10,
                                ),
                              ),
                              Expanded(
                                child: InputWithIcon(
                                  controller: cityInputController,
                                  placeholder: 'Miejscowosć *',
                                  initialValue:
                                      _formInitialsState[USER_DATA_INPUTS.CITY],
                                  onChange: (e) {
                                    setState(() {
                                      _formFieldsState[USER_DATA_INPUTS.CITY] =
                                          e.trim();
                                      _formErrorsState[USER_DATA_INPUTS.CITY] =
                                          '';
                                    });
                                  },
                                  error:
                                      _formErrorsState[USER_DATA_INPUTS.CITY],
                                  outsideLabel: 'Miejscowosć',
                                  verticalPadding: 12,
                                  borderRadius: 10,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dane firmy',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: colors.tertiary)),
                              Text(
                                  'Uzupełnij dane firmy, jeśli chcesz otrzymać fakturę',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: colors.tertiaryContainer)),
                            ],
                          ),
                          Container(
                            height: 0.1,
                            color: colors.tertiary,
                          ),
                          InputWithIcon(
                            placeholder: 'Nazwa firmy',
                            initialValue: _formInitialsState[
                                USER_DATA_INPUTS.COMPANY_NAME],
                            onChange: (e) {
                              setState(() {
                                _formFieldsState[
                                    USER_DATA_INPUTS.COMPANY_NAME] = e.trim();
                                _formErrorsState[
                                    USER_DATA_INPUTS.COMPANY_NAME] = '';
                              });
                            },
                            error:
                                _formErrorsState[USER_DATA_INPUTS.COMPANY_NAME],
                            outsideLabel: 'Nazwa firmy',
                            verticalPadding: 12,
                            borderRadius: 10,
                          ),
                          InputWithIcon(
                            inputType: TextInputType.number,
                            initialValue:
                                _formInitialsState[USER_DATA_INPUTS.NIP],
                            placeholder: 'NIP',
                            onChange: (e) {
                              setState(() {
                                _formFieldsState[USER_DATA_INPUTS.NIP] =
                                    e.trim();
                                _formErrorsState[USER_DATA_INPUTS.NIP] = '';
                              });
                            },
                            error: _formErrorsState[USER_DATA_INPUTS.NIP],
                            outsideLabel: 'NIP',
                            verticalPadding: 12,
                            borderRadius: 10,
                          ),
                          Text(
                            'Administratorem twoich danych osobowych jest FinFit sp. z.o.o. z siedzibą w Warszawie, ul. Nowa 1, 00-001 Warszawa. Twoje dane osobowe będą przetwarzane w celu realizacji zamówienia oraz wystawienia faktury. Masz prawo dostępu do treści swoich danych oraz ich poprawiania.',
                            style: TextStyle(
                                fontSize: 11,
                                color: colors.tertiaryContainer.withAlpha(150)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CheckboxWithLabel(
                    checked: isInvoice ?? false,
                    label: 'Chcę fakturę',
                    onChanged: (bool? val) {
                      setState(() {
                        isInvoice = val;
                      });
                    }),
                MainButton(
                    label: 'Potwierdź',
                    backgroundColor: colors.secondary,
                    textColor: colors.primary,
                    isDisabled: _formErrorsState.values
                        .any((error) => error != null && error.isNotEmpty),
                    onPressed: () {
                      setErrors();

                      if (_formErrorsState.values
                          .any((error) => error != null && error.isNotEmpty)) {
                        return;
                      }

                      final IUserOrderData userOrderData = IUserOrderData(
                        firstName: _formFieldsState[USER_DATA_INPUTS.NAME]!,
                        lastName: _formFieldsState[USER_DATA_INPUTS.SURNAME]!,
                        email: _formFieldsState[USER_DATA_INPUTS.EMAIL]!,
                        phoneNumber:
                            _formFieldsState[USER_DATA_INPUTS.PHONE_NUMBER]!,
                        address: IAddressDetails(
                            country: 'Poland',
                            city: _formFieldsState[USER_DATA_INPUTS.CITY]!,
                            street: _formFieldsState[USER_DATA_INPUTS.STREET]!,
                            postCode:
                                _formFieldsState[USER_DATA_INPUTS.POST_CODE]!,
                            houseNumber: _formFieldsState[
                                USER_DATA_INPUTS.HOUSE_NUMBER]!,
                            flatNumber:
                                _formFieldsState[USER_DATA_INPUTS.FLAT_NUMBER]),
                        companyData: isInvoice == true
                            ? ICompanyData(
                                name: _formFieldsState[
                                    USER_DATA_INPUTS.COMPANY_NAME]!,
                                nip: _formFieldsState[USER_DATA_INPUTS.NIP]!)
                            : null,
                      );

                      checkoutController.setUserOrderData(userOrderData);
                      widget.nextPage();
                    }),
              ],
            ),
          );
        });
  }
}

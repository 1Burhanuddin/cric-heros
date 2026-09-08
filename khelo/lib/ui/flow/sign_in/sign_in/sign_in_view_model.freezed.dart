// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignInState {
  TextEditingController get emailController =>
      throw _privateConstructorUsedError;
  TextEditingController get passwordController =>
      throw _privateConstructorUsedError;
  bool get obscurePassword => throw _privateConstructorUsedError;
  bool get enableBtn => throw _privateConstructorUsedError;
  bool get googleSigningIn => throw _privateConstructorUsedError;
  bool get emailSigningIn => throw _privateConstructorUsedError;
  bool get signInSuccess => throw _privateConstructorUsedError;
  Object? get actionError => throw _privateConstructorUsedError;

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignInStateCopyWith<SignInState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInStateCopyWith<$Res> {
  factory $SignInStateCopyWith(
          SignInState value, $Res Function(SignInState) then) =
      _$SignInStateCopyWithImpl<$Res, SignInState>;
  @useResult
  $Res call(
      {TextEditingController emailController,
      TextEditingController passwordController,
      bool obscurePassword,
      bool enableBtn,
      bool googleSigningIn,
      bool emailSigningIn,
      bool signInSuccess,
      Object? actionError});
}

/// @nodoc
class _$SignInStateCopyWithImpl<$Res, $Val extends SignInState>
    implements $SignInStateCopyWith<$Res> {
  _$SignInStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailController = null,
    Object? passwordController = null,
    Object? obscurePassword = null,
    Object? enableBtn = null,
    Object? googleSigningIn = null,
    Object? emailSigningIn = null,
    Object? signInSuccess = null,
    Object? actionError = freezed,
  }) {
    return _then(_value.copyWith(
      emailController: null == emailController
          ? _value.emailController
          : emailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      passwordController: null == passwordController
          ? _value.passwordController
          : passwordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      obscurePassword: null == obscurePassword
          ? _value.obscurePassword
          : obscurePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      googleSigningIn: null == googleSigningIn
          ? _value.googleSigningIn
          : googleSigningIn // ignore: cast_nullable_to_non_nullable
              as bool,
      emailSigningIn: null == emailSigningIn
          ? _value.emailSigningIn
          : emailSigningIn // ignore: cast_nullable_to_non_nullable
              as bool,
      signInSuccess: null == signInSuccess
          ? _value.signInSuccess
          : signInSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignInStateImplCopyWith<$Res>
    implements $SignInStateCopyWith<$Res> {
  factory _$$SignInStateImplCopyWith(
          _$SignInStateImpl value, $Res Function(_$SignInStateImpl) then) =
      __$$SignInStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TextEditingController emailController,
      TextEditingController passwordController,
      bool obscurePassword,
      bool enableBtn,
      bool googleSigningIn,
      bool emailSigningIn,
      bool signInSuccess,
      Object? actionError});
}

/// @nodoc
class __$$SignInStateImplCopyWithImpl<$Res>
    extends _$SignInStateCopyWithImpl<$Res, _$SignInStateImpl>
    implements _$$SignInStateImplCopyWith<$Res> {
  __$$SignInStateImplCopyWithImpl(
      _$SignInStateImpl _value, $Res Function(_$SignInStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailController = null,
    Object? passwordController = null,
    Object? obscurePassword = null,
    Object? enableBtn = null,
    Object? googleSigningIn = null,
    Object? emailSigningIn = null,
    Object? signInSuccess = null,
    Object? actionError = freezed,
  }) {
    return _then(_$SignInStateImpl(
      emailController: null == emailController
          ? _value.emailController
          : emailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      passwordController: null == passwordController
          ? _value.passwordController
          : passwordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      obscurePassword: null == obscurePassword
          ? _value.obscurePassword
          : obscurePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      googleSigningIn: null == googleSigningIn
          ? _value.googleSigningIn
          : googleSigningIn // ignore: cast_nullable_to_non_nullable
              as bool,
      emailSigningIn: null == emailSigningIn
          ? _value.emailSigningIn
          : emailSigningIn // ignore: cast_nullable_to_non_nullable
              as bool,
      signInSuccess: null == signInSuccess
          ? _value.signInSuccess
          : signInSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      actionError: freezed == actionError ? _value.actionError : actionError,
    ));
  }
}

/// @nodoc

class _$SignInStateImpl implements _SignInState {
  const _$SignInStateImpl(
      {required this.emailController,
      required this.passwordController,
      this.obscurePassword = true,
      this.enableBtn = false,
      this.googleSigningIn = false,
      this.emailSigningIn = false,
      this.signInSuccess = false,
      this.actionError});

  @override
  final TextEditingController emailController;
  @override
  final TextEditingController passwordController;
  @override
  @JsonKey()
  final bool obscurePassword;
  @override
  @JsonKey()
  final bool enableBtn;
  @override
  @JsonKey()
  final bool googleSigningIn;
  @override
  @JsonKey()
  final bool emailSigningIn;
  @override
  @JsonKey()
  final bool signInSuccess;
  @override
  final Object? actionError;

  @override
  String toString() {
    return 'SignInState(emailController: $emailController, passwordController: $passwordController, obscurePassword: $obscurePassword, enableBtn: $enableBtn, googleSigningIn: $googleSigningIn, emailSigningIn: $emailSigningIn, signInSuccess: $signInSuccess, actionError: $actionError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInStateImpl &&
            (identical(other.emailController, emailController) ||
                other.emailController == emailController) &&
            (identical(other.passwordController, passwordController) ||
                other.passwordController == passwordController) &&
            (identical(other.obscurePassword, obscurePassword) ||
                other.obscurePassword == obscurePassword) &&
            (identical(other.enableBtn, enableBtn) ||
                other.enableBtn == enableBtn) &&
            (identical(other.googleSigningIn, googleSigningIn) ||
                other.googleSigningIn == googleSigningIn) &&
            (identical(other.emailSigningIn, emailSigningIn) ||
                other.emailSigningIn == emailSigningIn) &&
            (identical(other.signInSuccess, signInSuccess) ||
                other.signInSuccess == signInSuccess) &&
            const DeepCollectionEquality()
                .equals(other.actionError, actionError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      emailController,
      passwordController,
      obscurePassword,
      enableBtn,
      googleSigningIn,
      emailSigningIn,
      signInSuccess,
      const DeepCollectionEquality().hash(actionError));

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInStateImplCopyWith<_$SignInStateImpl> get copyWith =>
      __$$SignInStateImplCopyWithImpl<_$SignInStateImpl>(this, _$identity);
}

abstract class _SignInState implements SignInState {
  const factory _SignInState(
      {required final TextEditingController emailController,
      required final TextEditingController passwordController,
      final bool obscurePassword,
      final bool enableBtn,
      final bool googleSigningIn,
      final bool emailSigningIn,
      final bool signInSuccess,
      final Object? actionError}) = _$SignInStateImpl;

  @override
  TextEditingController get emailController;
  @override
  TextEditingController get passwordController;
  @override
  bool get obscurePassword;
  @override
  bool get enableBtn;
  @override
  bool get googleSigningIn;
  @override
  bool get emailSigningIn;
  @override
  bool get signInSuccess;
  @override
  Object? get actionError;

  /// Create a copy of SignInState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignInStateImplCopyWith<_$SignInStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

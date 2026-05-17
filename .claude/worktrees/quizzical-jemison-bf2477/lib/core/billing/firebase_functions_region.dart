/// Region where Firebase Callable / HTTPS functions are deployed.
/// Supplied via `--dart-define-from-file=config/dart_defines.json`
const kFirebaseFunctionsRegion = String.fromEnvironment('FUNCTIONS_REGION');

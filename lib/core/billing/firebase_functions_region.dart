/// Region where Firebase Callable / HTTPS functions are deployed.
/// Override at build time: `--dart-define=FUNCTIONS_REGION=europe-west1`
const kFirebaseFunctionsRegion = String.fromEnvironment(
  'FUNCTIONS_REGION',
  defaultValue: 'us-central1',
);

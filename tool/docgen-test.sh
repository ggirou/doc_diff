OUTDIR="../test/docs"
PARAMS="--out $OUTDIR --package-root=../packages --no-json --no-include-sdk --exclude-lib "dart-core" --no-include-dependent-packages"

mkdir -p $OUTDIR
docgen $PARAMS/old ../test/samples/docold.dart
docgen $PARAMS/new ../test/samples/docnew.dart

rm $OUTDIR/old/dart-core*
rm $OUTDIR/new/dart-core*

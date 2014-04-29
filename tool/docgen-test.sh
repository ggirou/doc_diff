OUTDIR="$PWD/../test/docs"
PARAMS="--verbose --package-root=../packages --no-include-sdk --exclude-lib dart:core --no-include-dependent-packages"

mkdir -p $OUTDIR
docgen $PARAMS --out $OUTDIR/old ../test/samples/docold.dart
docgen $PARAMS --out $OUTDIR/new ../test/samples/docnew.dart

#rm $OUTDIR/old/dart-core*
#rm $OUTDIR/new/dart-core*

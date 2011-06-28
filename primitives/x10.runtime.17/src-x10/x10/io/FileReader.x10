package x10.io;

import x10.compiler.Native;
import x10.compiler.NativeRep;

public /*value*/ class FileReader extends InputStreamReader {
    val file: File;

    @NativeRep("java", "java.io.FileInputStream", null, null)
    @NativeRep("c++", "x10aux::ref<x10::io::FileInputStream>", "x10::io::FileInputStream", null)
    protected static /*value*/ class FileInputStream extends InputStream {
        public native def this(String);
    }

    public def this(file: File) throws IOException {
        super(new FileInputStream(file.getPath()));
        this.file = file;
    }
}
import java.io.File;
import java.io.FileInputStream;
import java.util.Base64;


public class Uploader {

    public static String encodeFileToBase64(String path) throws Exception {
        File file = new File(path);
        byte[] bytes = new byte[(int) file.length()];
        try (FileInputStream fis = new FileInputStream(file)) {
            fis.read(bytes);
        }
        return Base64.getEncoder().encodeToString(bytes);
    }

    public static String encodeBytesToBase64(byte[] bytes) {
        return Base64.getEncoder().encodeToString(bytes);
    }
}

package com.generatorproject.config;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

public class AppConfig {

    private static final Properties PROPS = new Properties();
    private static volatile boolean loaded = false;

    private AppConfig() {
    }

    public static String get(String key) {
        loadIfNeeded();
        return normalize(PROPS.getProperty(key));
    }

    public static String getOrDefault(String key, String defaultValue) {
        String value = get(key);
        return value == null ? defaultValue : value;
    }

    public static void reload() {
        synchronized (AppConfig.class) {
            PROPS.clear();
            loaded = false;
        }
        loadIfNeeded();
    }

    private static void loadIfNeeded() {
        if (loaded) {
            return;
        }

        synchronized (AppConfig.class) {
            if (loaded) {
                return;
            }

            String customPath = firstNonBlank(
                    System.getProperty("app.config.file"),
                    System.getenv("APP_CONFIG_FILE"));

            boolean loadedFromFile = false;
            if (customPath != null) {
                loadedFromFile = loadFromFile(customPath);
            }

            if (!loadedFromFile) {
                loadedFromFile = loadFromFile("/usr/local/tomcat/conf/application.properties");
            }

            if (!loadedFromFile) {
                String catalinaBase = normalize(System.getProperty("catalina.base"));
                if (catalinaBase != null) {
                    loadedFromFile = loadFromFile(catalinaBase + File.separator + "conf"
                            + File.separator + "application.properties");
                }
            }

            if (!loadedFromFile) {
                loadedFromFile = loadFromFile("application.properties");
            }

            if (!loadedFromFile) {
                loadedFromFile = tryLoadFromParentChain(System.getProperty("user.dir"), 4);
            }

            if (!loadedFromFile) {
                loadedFromFile = tryLoadFromParentChain(System.getProperty("catalina.base"), 4);
            }

            if (!loadedFromFile) {
                loadedFromFile = tryLoadFromParentChain(System.getProperty("catalina.home"), 4);
            }

            if (!loadedFromFile) {
                loadFromClasspath("application.properties");
            }

            loaded = true;
        }
    }

    private static boolean loadFromFile(String path) {
        try {
            File file = new File(path);
            if (!file.exists() || !file.isFile()) {
                return false;
            }

            try (InputStream is = new FileInputStream(file)) {
                PROPS.load(is);
                return true;
            }
        } catch (Exception ignored) {
            return false;
        }
    }

    private static void loadFromClasspath(String resourceName) {
        try (InputStream is = AppConfig.class.getClassLoader().getResourceAsStream(resourceName)) {
            if (is != null) {
                PROPS.load(is);
            }
        } catch (Exception ignored) {
        }
    }

    private static boolean tryLoadFromParentChain(String startPath, int maxDepth) {
        String normalizedStart = normalize(startPath);
        if (normalizedStart == null) {
            return false;
        }

        File current = new File(normalizedStart);
        if (!current.exists()) {
            return false;
        }

        if (current.isFile()) {
            current = current.getParentFile();
        }

        int depth = 0;
        while (current != null && depth <= maxDepth) {
            File candidate = new File(current, "application.properties");
            if (loadFromFile(candidate.getAbsolutePath())) {
                return true;
            }
            current = current.getParentFile();
            depth++;
        }

        return false;
    }

    private static String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            String normalized = normalize(value);
            if (normalized != null) {
                return normalized;
            }
        }
        return null;
    }

    private static String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}

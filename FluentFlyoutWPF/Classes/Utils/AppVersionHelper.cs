// Copyright (c) 2024-2026 The FluentFlyout Authors
// SPDX-License-Identifier: GPL-3.0-or-later

using System.Diagnostics;
using Windows.ApplicationModel;

namespace FluentFlyoutWPF.Classes.Utils
{
    /// <summary>
    /// Resolves the app version for both MSIX-packaged and unpackaged builds.
    /// Packaged builds read it from the package identity, unpackaged ones from the
    /// version stamped into the executable at build time.
    /// </summary>
    internal static class AppVersionHelper
    {
        /// <summary>
        /// Returns the version as "vMAJOR.MINOR.BUILD", or null if it cannot be determined.
        /// </summary>
        public static string? GetVersion()
        {
            try // packaged (MSIX / Store) build
            {
                var version = Package.Current.Id.Version;
                return $"v{version.Major}.{version.Minor}.{version.Build}";
            }
            catch { }

            try // unpackaged build, version comes from the .exe itself
            {
                string? path = Environment.ProcessPath;
                if (!string.IsNullOrEmpty(path))
                {
                    var info = FileVersionInfo.GetVersionInfo(path);
                    if (info.FileMajorPart != 0 || info.FileMinorPart != 0 || info.FileBuildPart != 0)
                        return $"v{info.FileMajorPart}.{info.FileMinorPart}.{info.FileBuildPart}";
                }
            }
            catch { }

            return null;
        }
    }
}

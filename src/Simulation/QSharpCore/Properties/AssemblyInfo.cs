// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// Allow the simulator assembly to use our internal methods
[assembly: InternalsVisibleTo("Microsoft.Quantum.Simulators" + SigningConstants.PUBLIC_KEY)]
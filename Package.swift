// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "myProject2",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
		// 💧 A server-side Swift web framework.
		.package(url: "https://github.com/vapor/vapor.git", from: "4.5.0"),
		.package(url: "https://github.com/vapor/leaf.git", from: "4.0.0-rc.1"),
		.package(url: "https://github.com/vapor/fluent.git", from: "4.0.0-rc"),
		.package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0-rc"),
		.package(url: "https://github.com/binarybirds/liquid.git", from: "1.0.0"),
		.package(url: "https://github.com/binarybirds/liquid-local-driver.git", from: "1.0.0"),
		.package(url: "https://github.com/binarybirds/liquid-aws-s3-driver.git", from: "1.0.0"),
		.package(url: "https://github.com/vapor/fluent-postgres-driver", from: "2.0.0-rc"),
		.package(url: "https://github.com/binarybirds/view-kit.git", from: "1.0.0"),
		.package(url: "https://github.com/binarybirds/content-api.git", from: "1.0.0"),
		.package(url: "https://github.com/binarybirds/viper-kit.git", from: "1.0.0"),
		.package(url: "https://github.com/binarybirds/spec.git", from: "1.0.0"),
		.package(url: "https://github.com/mredig/MyProjectApi.git", from: "1.0.0"),
//		.package(name: "MyProjectApi", path: "../MyProjectApi"),
		.package(url: "https://github.com/vapor/jwt.git", from: "4.0.0-rc"),
		// 0.8.0 was last release at this time, but didn't contain the changes I contributed.
		.package(url: "https://github.com/JohnSundell/Plot.git", .branch("master")),
	],
    targets: [
        .target(
            name: "App",
            dependencies: [
				.product(name: "Leaf", package: "leaf"),
				.product(name: "Fluent", package: "fluent"),
				.product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
				.product(name: "Vapor", package: "vapor"),
				.product(name: "Liquid", package: "liquid"),
				.product(name: "LiquidAwsS3Driver", package: "liquid-aws-s3-driver"),
				.product(name: "ViewKit", package: "view-kit"),
				.product(name: "ContentApi", package: "content-api"),
				.product(name: "ViperKit", package: "viper-kit"),
				.product(name: "MyProjectApi", package: "MyProjectApi"),
				.product(name: "JWT", package: "jwt"),
				.product(name: "Plot", package: "Plot"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
			.product(name: "Spec", package: "spec"),
			.product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
			.product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
        ])
    ]
)

#pragma once

#include <QDebug>
#include <QFlags>
#include <QString>
#include <QVector>
#include <QVariant>
#include <QDateTime>
#include <QByteArray>
#include <QDataStream>
#include <QCryptographicHash>


class CryptoGraphy
{
public:
	enum CompressionMode {
		CompressionModeAuto,
		CompressionModeAlways,
		CompressionModeNever
	};

	enum ProtectionMode {
		ProtectionModeNone,
		ProtectionModeChecksum,
		ProtectionModeHash
	};

	enum CryptoFlag {
		CryptoFlagNone = 0,
		CryptoFlagCompression = 0x01,
		CryptoFlagChecksum = 0x02,
		CryptoFlagHash = 0x04
	};

	Q_DECLARE_FLAGS(CryptoFlags, CryptoFlag)

	CryptoGraphy();

	explicit CryptoGraphy(const quint64 &);

	void setKey(const quint64 &);

	bool hasKey() const;

	void setCompressionMode(const CompressionMode &);

	CompressionMode getCompressionMode() const;

	void setProtectionMode(const ProtectionMode &);

	ProtectionMode getProtectionMode() const;

	QVariant encrypt(const QVariant &);
	QVariant decrypt(const QVariant &);

private:
	quint64 m_key {};
	QVector<char> m_keyParts {};
	CompressionMode m_compressionMode {};
	ProtectionMode m_protectionMode {};

	void splitKey();
};

Q_DECLARE_OPERATORS_FOR_FLAGS(CryptoGraphy::CryptoFlags)
